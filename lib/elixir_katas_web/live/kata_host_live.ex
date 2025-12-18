defmodule ElixirKatasWeb.KataHostLive do
  use ElixirKatasWeb, :live_view
  alias ElixirKatas.Katas.DynamicCompiler
  import ElixirKatasWeb.KataComponents

  def mount(params, session, socket) do
    kata_id = Map.get(params, "kata_id", "01")
    
    user_token = session["user_token"]
    user = 
      if user_token do
        case ElixirKatas.Accounts.get_user_by_session_token(user_token) do
          {user, _token} -> user
          _ -> nil
        end
      end
    
    user_id = if user, do: user.id, else: 0
    
    # 1. Load Source
    base_file = "lib/elixir_katas_web/live/kata_#{kata_id}_hello_world_live.ex" 
    file_source = File.read!(base_file)

    # Check DB for User Version
    {source_code, is_user_author} =
      if user_id != 0 do
         case ElixirKatas.Katas.get_user_kata(user_id, "Kata#{kata_id}") do
            nil -> {file_source, false}
            user_kata -> {user_kata.source_code, true}
         end
      else
         {file_source, false}
      end
    
    # 2. Compile Initial
    # Always recompile if it's the user's custom version to ensure the module is fresh in memory.
    # If it's the default file, we still compile it for the "Hot Seat" (to get a unique module name for this user/session).
    {dynamic_module, flash} = 
      case DynamicCompiler.compile(user_id, "Kata#{kata_id}", source_code) do
         {:ok, module} -> {module, nil}
         {:error, err} -> {nil, {:error, "Initial compilation failed: #{inspect(err)}. Please fix the source code."}}
      end

    # 3. Load Notes
    notes_path = "notes/kata_01_hello_world_notes.md" # hardcoded for PoC
    notes_content = 
        if File.exists?(notes_path), do: File.read!(notes_path), else: "Notes not found."

    {:ok, 
     socket
     |> assign(:dynamic_module, dynamic_module)
     |> assign(:source_code, source_code)
     |> assign(:user_id, user_id)
     |> assign(:kata_id, kata_id) # Need this for saving
     |> assign(:active_tab, "interactive")
     |> assign(:notes_content, notes_content)
     |> assign(:read_only, false) # PoC is always editable
     |> assign(:is_user_author, is_user_author)
     |> assign(:compiling, false)
     |> then(fn s -> 
        if flash do
          {type, msg} = flash
          put_flash(s, type, msg)
        else
          s
        end
     end)
    }
  end

  def render(assigns) do
    ~H"""
    <div class="h-screen w-full relative">
      <%= if @compiling do %>
        <div class="absolute top-4 right-4 z-50">
           <span class="loading loading-spinner text-primary"></span>
           <span class="ml-2 text-sm text-gray-500">Compiling...</span>
        </div>
      <% end %>

      <.kata_viewer 
        active_tab={@active_tab}
        title="Kata 01: Hello World"
        source_code={@source_code}
        notes_content={@notes_content}
        read_only={@read_only}
        is_user_author={@is_user_author}
      >
        <div class="h-full w-full">
             <.live_component module={@dynamic_module} id="kata-sandbox" />
        </div>
      </.kata_viewer>
    </div>
    """
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end

  def handle_event("save_source", %{"source" => source}, socket) do
     user_id = socket.assigns.user_id
     kata_id = socket.assigns.kata_id
     kata_name = "Kata#{kata_id}"

     # Start Async Task
     task = Task.async(fn -> 
        # 1. Compile
        compile_result = DynamicCompiler.compile(user_id, kata_name, source)
        
        # 2. Persist if success equivalent (compile doesn't prevent saving generally, but good to check)
        # Actually, we should probably save even if it fails compiling? 
        # For now, let's follows previous logic: save if logged in (effectively)
        
        if user_id != 0 do
           ElixirKatas.Katas.save_user_kata(user_id, kata_name, source)
        end
        
        compile_result
     end)

     {:noreply, 
      socket
      |> assign(:compiling, true)
     }
  end

  def handle_info({ref, result}, socket) do
    Process.demonitor(ref, [:flush])
    
    case result do
      {:ok, new_module} ->
        {:noreply, 
         socket
         |> assign(:compiling, false)
         |> assign(:dynamic_module, new_module)
         |> assign(:is_user_author, true)
         |> put_flash(:info, "Saved & Compiled!")
        }
      
      {:error, err} ->
         {:noreply, 
          socket
          |> assign(:compiling, false)
          |> put_flash(:error, "Compilation failed: #{inspect(err)}")
         }
    end
  end

  # Handle task crashing
  def handle_info({:DOWN, _ref, :process, _pid, reason}, socket) do
     {:noreply, 
      socket
      |> assign(:compiling, false)
      |> put_flash(:error, "Compiler crashed: #{inspect(reason)}")
     }
  end
  
  def handle_event("revert", _, socket) do
     user_id = socket.assigns.user_id
     kata_id = socket.assigns.kata_id
     kata_name = "Kata#{kata_id}"
     
     if user_id != 0 do
       # 1. Delete user version
       ElixirKatas.Katas.delete_user_kata(user_id, kata_name)
       
       # 2. Reload generic version
       base_file = "lib/elixir_katas_web/live/kata_#{kata_id}_hello_world_live.ex" 
       source_code = File.read!(base_file)
       
       # 3. Recompile generic version
       {:ok, module} = DynamicCompiler.compile(user_id, kata_name, source_code)
       
       {:noreply,
        socket
        |> assign(:source_code, source_code)
        |> assign(:dynamic_module, module)
        |> assign(:is_user_author, false)
        |> put_flash(:info, "Reverted to original version!")
       }
     else
        {:noreply, put_flash(socket, :error, "Cannot revert as Guest.")}
     end
  end
end
