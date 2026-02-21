defmodule ElixirKatasWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use ElixirKatasWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  def app(assigns) do
    ~H"""
    <div class="flex h-full bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100 font-sans">
      <!-- Sidebar -->
      <div id="sidebar" class="w-64 flex-shrink-0 bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700 flex flex-col transition-all duration-300 ease-in-out" data-layout-source="custom-app">
        <div class="h-16 flex items-center px-6 border-b border-gray-200 dark:border-gray-700">
          <span class="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-purple-600 to-pink-600">
            Phoenix LiveView Katas
          </span>
        </div>
        <div class="flex-1 overflow-y-auto p-4" phx-hook="ScrollPosition" data-scroll-key="sidebar-nav" id="sidebar-nav">
          <nav class="space-y-1">
            <a href="/" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md bg-purple-50 dark:bg-purple-900/20 text-purple-700 dark:text-purple-300">
              <.icon name="hero-home" class="mr-3 h-5 w-5 text-purple-600 dark:text-purple-400" />
              Home
            </a>
            
            <div class="mt-8">
              <h3 class="px-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                Learning Logic
              </h3>
              <div class="mt-2 space-y-1 pl-2">
                  <!-- Example Kata Link -->
                 <.link navigate="/katas/00-liveview-basics" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-600 animate-pulse"></span>
                   00 - LiveView Basics
                 </.link>
                 <.link navigate="/katas/01-hello-world" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-400"></span>
                   01 - Hello World
                 </.link>
                 <.link navigate="/katas/02-counter" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-400"></span>
                   02 - Counter
                 </.link>
                 <.link navigate="/katas/03-mirror" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-400"></span>
                   03 - The Mirror
                 </.link>
                 <.link navigate="/katas/04-toggler" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-400"></span>
                   04 - The Toggler
                 </.link>
                 <.link navigate="/katas/05-color-picker" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-400"></span>
                   05 - Color Picker
                 </.link>
                 <.link navigate="/katas/06-resizer" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-teal-400"></span>
                   06 - The Resizer
                 </.link>
                 <.link navigate="/katas/07-spoiler" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-400"></span>
                   07 - The Spoiler
                 </.link>
                 <.link navigate="/katas/08-accordion" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-cyan-400"></span>
                   08 - The Accordion
                 </.link>
                 <.link navigate="/katas/09-tabs" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-400"></span>
                   09 - The Tabs
                 </.link>
                 <.link navigate="/katas/10-character-counter" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-400"></span>
                   10 - Character Counter
                 </.link>
                 <.link navigate="/katas/11-stopwatch" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-400"></span>
                   11 - The Stopwatch
                 </.link>
                 <.link navigate="/katas/12-timer" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-400"></span>
                   12 - The Timer
                 </.link>
                 <.link navigate="/katas/13-events-mastery" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-400"></span>
                   13 - Events Mastery
                 </.link>
                 <.link navigate="/katas/14-keybindings" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-400"></span>
                   14 - Keybindings
                 </.link>
                 <.link navigate="/katas/15-calculator" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-gray-400"></span>
                   15 - The Calculator
                 </.link>
                 <.link navigate="/katas/16-list" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-400"></span>
                   16 - The List
                 </.link>
                 <.link navigate="/katas/17-remover" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-400"></span>
                   17 - The Remover
                 </.link>
                 <.link navigate="/katas/18-editor" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-400"></span>
                   18 - The Editor
                 </.link>
                 <.link navigate="/katas/19-filter" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-cyan-400"></span>
                   19 - The Filter
                 </.link>
                 <.link navigate="/katas/20-sorter" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-teal-400"></span>
                   20 - The Sorter
                 </.link>
                 <.link navigate="/katas/21-paginator" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-400"></span>
                   21 - The Paginator
                 </.link>
                 <.link navigate="/katas/22-highlighter" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-400"></span>
                   22 - The Highlighter
                 </.link>
                 <.link navigate="/katas/23-multi-select" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-400"></span>
                   23 - The Multi-Select
                 </.link>
                 <.link navigate="/katas/24-grid" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-cyan-400"></span>
                   24 - The Grid
                 </.link>
                 <.link navigate="/katas/25-tree" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-400"></span>
                   25 - The Tree
                 </.link>
                 <.link navigate="/katas/26-text-input" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-400"></span>
                   26 - The Text Input
                 </.link>
                 <.link navigate="/katas/27-checkbox" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-400"></span>
                   27 - The Checkbox
                 </.link>
                 <.link navigate="/katas/28-radio-buttons" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-400"></span>
                   28 - Radio Buttons
                 </.link>
                 <.link navigate="/katas/29-select" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-400"></span>
                   29 - The Select
                 </.link>
                 <.link navigate="/katas/30-multi-select-form" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-400"></span>
                   30 - Multi-Select Form
                 </.link>
                 <.link navigate="/katas/31-dependent-inputs" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-400"></span>
                   31 - Dependent Inputs
                 </.link>
                 <.link navigate="/katas/32-comparison-validation" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-400"></span>
                   32 - Comparison Validation
                 </.link>
                 <.link navigate="/katas/33-formats" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-400"></span>
                   33 - Formats
                 </.link>
                 <.link navigate="/katas/34-live-feedback" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-400"></span>
                   34 - Live Feedback
                 </.link>
                 <.link navigate="/katas/35-form-restoration" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-400"></span>
                   35 - Form Restoration
                 </.link>
                 <.link navigate="/katas/36-debounce" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-400"></span>
                   36 - Debounce
                 </.link>
                 <.link navigate="/katas/37-wizard" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-400"></span>
                   37 - The Wizard
                 </.link>
                 <.link navigate="/katas/38-tag-input" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-400"></span>
                   38 - The Tag Input
                 </.link>
                 <.link navigate="/katas/39-rating" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-400"></span>
                   39 - The Rating Input
                 </.link>
                 <.link navigate="/katas/40-uploads" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-400"></span>
                   40 - File Uploads
                  </.link>
                 <.link navigate="/katas/41-url-params" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   41 - URL Params
                 </.link>
                 <.link navigate="/katas/42-path-params/1" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-500"></span>
                   42 - Path Params
                 </.link>
                 <.link navigate="/katas/43-navbar" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-500"></span>
                   43 - The Nav Bar
                 </.link>
                 <.link navigate="/katas/44-breadcrumb" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-500"></span>
                   44 - The Breadcrumb
                 </.link>
                 <.link navigate="/katas/45-tabs-url" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                   45 - Tabs with URL
                 </.link>
                 <.link navigate="/katas/46-search-url" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-cyan-500"></span>
                   46 - Search with URL
                 </.link>
                 <.link navigate="/katas/47-protected" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-500"></span>
                   47 - Protected Routes
                 </.link>
                 <.link navigate="/katas/48-redirects" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-teal-500"></span>
                   48 - Live Redirects
                 </.link>
                 <.link navigate="/katas/49-translator" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-500"></span>
                   49 - The Translator
                 </.link>
                 <.link navigate="/katas/50-components" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-500"></span>
                   50 - Functional Components
                 </.link>
                 <.link navigate="/katas/51-card" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   51 - The Card
                 </.link>
                 <.link navigate="/katas/52-button" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-500"></span>
                   52 - The Button
                 </.link>
                 <.link navigate="/katas/53-icon" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-500"></span>
                   53 - The Icon
                 </.link>
                 <.link navigate="/katas/54-modal" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-500"></span>
                   54 - The Modal
                 </.link>
                 <.link navigate="/katas/55-slideover" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                   55 - The Slide-over
                 </.link>
                 <.link navigate="/katas/56-tooltip" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-cyan-500"></span>
                   56 - The Tooltip
                 </.link>
                 <.link navigate="/katas/57-dropdown" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-500"></span>
                   57 - The Dropdown
                 </.link>
                 <.link navigate="/katas/58-flash" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-teal-500"></span>
                   58 - Flash Messages
                 </.link>
                 <.link navigate="/katas/59-skeleton" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-500"></span>
                   59 - The Skeleton
                 </.link>
                 <.link navigate="/katas/60-progress" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-500"></span>
                   60 - The Progress Bar
                 </.link>
                 <.link navigate="/katas/61-stateful" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   61 - Stateful Component
                 </.link>
                 <.link navigate="/katas/62-component-id" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-500"></span>
                   62 - Component ID
                 </.link>
                 <.link navigate="/katas/63-send-update" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-500"></span>
                   63 - Send Update
                 </.link>
                 <.link navigate="/katas/64-send-self" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-500"></span>
                   64 - Send Self
                 </.link>
                 <.link navigate="/katas/65-child-parent" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                   65 - Child-to-Parent
                 </.link>
                 <.link navigate="/katas/66-sibling" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-cyan-500"></span>
                   66 - Sibling Communication
                 </.link>
                 <.link navigate="/katas/67-lazy" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-500"></span>
                   67 - Lazy Loading
                 </.link>
                 <.link navigate="/katas/68-changesets" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-teal-500"></span>
                   68 - Changesets 101
                 </.link>
                 <.link navigate="/katas/69-crud" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-500"></span>
                   69 - The CRUD
                 </.link>
                 <.link navigate="/katas/70-optimistic" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-500"></span>
                   70 - Optimistic UI
                 </.link>
                 <.link navigate="/katas/71-streams" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   71 - Streams Basic
                 </.link>
                 <.link navigate="/katas/72-infinite-scroll" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-500"></span>
                   72 - Infinite Scroll
                 </.link>
                 <.link navigate="/katas/73-stream-insert-delete" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-500"></span>
                   73 - Stream Insert/Delete
                 </.link>
                 <.link navigate="/katas/74-stream-reset" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-500"></span>
                   74 - Stream Reset
                 </.link>
                 <.link navigate="/katas/75-bulk-actions" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                   75 - Bulk Actions
                 </.link>
                 <.link navigate="/katas/76-clock" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   76 - The Clock
                 </.link>
                 <.link navigate="/katas/77-ticker" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                   77 - The Ticker
                 </.link>
                 <.link navigate="/katas/78-chat" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-500"></span>
                   78 - Chat Room
                 </.link>
                 <.link navigate="/katas/79-typing" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-500"></span>
                   79 - Typing Indicator
                 </.link>
                 <.link navigate="/katas/80-presence" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-500"></span>
                   80 - Presence List
                 </.link>
                 <.link navigate="/katas/81-cursor" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-500"></span>
                   81 - Live Cursor
                 </.link>
                 <.link navigate="/katas/82-notifications" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-500"></span>
                   82 - Distributed Notifications
                 </.link>
                 <.link navigate="/katas/83-game" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-500"></span>
                   83 - The Game State
                 </.link>
                 <.link navigate="/katas/84-focus" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   84 - Accessible Focus
                 </.link>
                 <.link navigate="/katas/85-scroll" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                   85 - Scroll to Bottom
                 </.link>
                 <.link navigate="/katas/86-clipboard" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-500"></span>
                   86 - Clipboard Copy
                 </.link>
                 <.link navigate="/katas/87-storage" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-500"></span>
                   87 - Local Storage
                 </.link>
                 <.link navigate="/katas/88-theme" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-500"></span>
                   88 - Theme Switcher
                 </.link>
                 <.link navigate="/katas/89-chart" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-500"></span>
                   89 - Chart.js
                 </.link>
                 <.link navigate="/katas/90-map" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-500"></span>
                   90 - Mapbox
                 </.link>
                 <.link navigate="/katas/91-masked" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-500"></span>
                   91 - Masked Input
                 </.link>
                 <.link navigate="/katas/92-dropzone" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   92 - File Dropzone
                 </.link>
                 <.link navigate="/katas/93-sortable" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                   93 - Sortable List
                 </.link>
                 <.link navigate="/katas/94-audio" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-purple-500"></span>
                   94 - Audio Player
                 </.link>
                 <.link navigate="/katas/95-async" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-pink-500"></span>
                   95 - Async Assigns
                 </.link>
                 <.link navigate="/katas/96-uploads" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-red-500"></span>
                   96 - File Uploads
                 </.link>
                 <.link navigate="/katas/97-images" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-orange-500"></span>
                   97 - Image Processing
                 </.link>
                 <.link navigate="/katas/98-pdf" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-yellow-500"></span>
                   98 - PDF Generation
                 </.link>
                 <.link navigate="/katas/99-csv" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-green-500"></span>
                   99 - CSV Export
                 </.link>
                 <.link navigate="/katas/100-error" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                   <span class="w-2 h-2 mr-3 rounded-full bg-blue-500"></span>
                   100 - Error Boundary
                 </.link>
                  <.link navigate="/katas/104-genserver" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                    <span class="w-2 h-2 mr-3 rounded-full bg-indigo-500"></span>
                    104 - GenServer Integration
                  </.link>
                  <.link navigate="/katas/125-statemachine" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                     <span class="w-2 h-2 mr-3 rounded-full bg-yellow-500"></span>
                     125 - State Machine
                   </.link>
                   <.link navigate="/katas/139-virtual-scrolling" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                    <span class="w-2 h-2 mr-3 rounded-full bg-orange-500"></span>
                    139 - Virtual Scrolling
                  </.link>
                  <.link navigate="/katas/140-confirm-dialog" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white">
                    <span class="w-2 h-2 mr-3 rounded-full bg-teal-500"></span>
                    140 - Confirm Dialog
                  </.link>

              </div>
            </div>
          </nav>
        </div>
        <div class="p-4 border-t border-gray-200 dark:border-gray-700">
             <div class="flex justify-center">
                <.theme_toggle />
             </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="flex-1 flex flex-col overflow-hidden relative">
        <header class="flex items-center justify-between h-16 px-6 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
          <!-- Burger Menu Button -->
          <button
            id="sidebar-toggle"
            class="p-2 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            onclick="toggleSidebar()"
            aria-label="Toggle sidebar"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
            </svg>
          </button>
          <span class="text-lg font-bold md:hidden">Phoenix LiveView Katas</span>
          <div class="w-10"></div> <!-- Spacer for mobile centering -->
        </header>

        <main class="flex-1 overflow-y-auto bg-gray-50 dark:bg-gray-900 p-4 sm:p-6 lg:p-8">
           <.flash_group flash={@flash} />
           <div class="mx-auto max-w-5xl">
             {@inner_content}
           </div>
        </main>
      </div>
    </div>
    <script>
      function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const isHidden = sidebar.classList.contains('-ml-64');
        
        if (isHidden) {
          sidebar.classList.remove('-ml-64');
        } else {
          sidebar.classList.add('-ml-64');
        }
      }
    </script>
    """
  end

  @elixir_kata_sections [
    %{title: "Section 1: Types & Basics", katas: [
      %{num: "01", slug: "01-type-explorer", label: "01 - Type Explorer", color: "bg-emerald-400"},
      %{num: "02", slug: "02-arithmetic-lab", label: "02 - Arithmetic Lab", color: "bg-teal-400"},
      %{num: "03", slug: "03-string-playground", label: "03 - String Playground", color: "bg-emerald-500"},
      %{num: "04", slug: "04-atoms-booleans", label: "04 - Atoms & Booleans", color: "bg-teal-500"},
      %{num: "05", slug: "05-comparison", label: "05 - Comparison", color: "bg-emerald-600"},
      %{num: "06", slug: "06-tuples", label: "06 - Tuples", color: "bg-teal-600"},
      %{num: "07", slug: "07-lists", label: "07 - Lists", color: "bg-emerald-400"},
      %{num: "08", slug: "08-maps-keywords", label: "08 - Maps & Keywords", color: "bg-teal-400"}
    ]},
    %{title: "Section 2: Pattern Matching", katas: [
      %{num: "09", slug: "09-match-operator", label: "09 - Match Operator", color: "bg-emerald-500"},
      %{num: "10", slug: "10-tuple-matching", label: "10 - Tuple Matching", color: "bg-teal-500"},
      %{num: "11", slug: "11-list-matching", label: "11 - List Matching", color: "bg-emerald-600"},
      %{num: "12", slug: "12-map-matching", label: "12 - Map Matching", color: "bg-teal-600"},
      %{num: "13", slug: "13-pin-operator", label: "13 - Pin Operator", color: "bg-emerald-400"},
      %{num: "14", slug: "14-multi-clause", label: "14 - Multi-clause", color: "bg-teal-400"},
      %{num: "15", slug: "15-destructuring", label: "15 - Destructuring", color: "bg-emerald-500"},
      %{num: "16", slug: "16-matching-challenges", label: "16 - Challenges", color: "bg-teal-500"}
    ]},
    %{title: "Section 3: Functions", katas: [
      %{num: "17", slug: "17-anonymous-functions", label: "17 - Anonymous Functions", color: "bg-emerald-500"},
      %{num: "18", slug: "18-named-functions", label: "18 - Named Functions", color: "bg-teal-500"},
      %{num: "19", slug: "19-guards", label: "19 - Guards", color: "bg-emerald-600"},
      %{num: "20", slug: "20-default-arguments", label: "20 - Default Arguments", color: "bg-teal-600"},
      %{num: "21", slug: "21-capture-operator", label: "21 - Capture Operator", color: "bg-emerald-400"},
      %{num: "22", slug: "22-recursion", label: "22 - Recursion", color: "bg-teal-400"},
      %{num: "23", slug: "23-tail-call", label: "23 - Tail Call", color: "bg-emerald-500"},
      %{num: "24", slug: "24-higher-order", label: "24 - Higher-Order Functions", color: "bg-teal-500"}
    ]},
    %{title: "Section 4: Control Flow", katas: [
      %{num: "25", slug: "25-case-expressions", label: "25 - Case Expressions", color: "bg-emerald-400"},
      %{num: "26", slug: "26-cond-expressions", label: "26 - Cond Expressions", color: "bg-teal-400"},
      %{num: "27", slug: "27-if-unless", label: "27 - If/Unless", color: "bg-emerald-500"},
      %{num: "28", slug: "28-with-expressions", label: "28 - With Expressions", color: "bg-teal-500"},
      %{num: "29", slug: "29-pipe-operator", label: "29 - Pipe Operator", color: "bg-emerald-600"},
      %{num: "30", slug: "30-comprehensions", label: "30 - Comprehensions", color: "bg-teal-600"},
      %{num: "31", slug: "31-try-rescue", label: "31 - Try/Rescue", color: "bg-emerald-400"}
    ]},
    %{title: "Section 5: Enum & Stream", katas: [
      %{num: "32", slug: "32-enum-basics", label: "32 - Enum Basics", color: "bg-emerald-500"},
      %{num: "33", slug: "33-enum-transforms", label: "33 - Enum Transforms", color: "bg-teal-500"},
      %{num: "34", slug: "34-enum-aggregates", label: "34 - Enum Aggregates", color: "bg-emerald-600"},
      %{num: "35", slug: "35-enum-search", label: "35 - Enum Search", color: "bg-teal-600"},
      %{num: "36", slug: "36-reduce-mastery", label: "36 - Reduce Mastery", color: "bg-emerald-400"},
      %{num: "37", slug: "37-mapset", label: "37 - MapSet", color: "bg-teal-400"},
      %{num: "38", slug: "38-streams-lazy", label: "38 - Streams: Lazy", color: "bg-emerald-500"},
      %{num: "39", slug: "39-stream-generators", label: "39 - Stream Generators", color: "bg-teal-500"},
      %{num: "40", slug: "40-ranges-slicing", label: "40 - Ranges & Slicing", color: "bg-emerald-600"}
    ]},
    %{title: "Section 6: Strings & Binaries", katas: [
      %{num: "41", slug: "41-string-deep-dive", label: "41 - String Deep Dive", color: "bg-emerald-400"},
      %{num: "42", slug: "42-charlists-strings", label: "42 - Charlists vs Strings", color: "bg-teal-400"},
      %{num: "43", slug: "43-string-matching", label: "43 - String Matching", color: "bg-emerald-500"},
      %{num: "44", slug: "44-regex", label: "44 - Regex", color: "bg-teal-500"},
      %{num: "45", slug: "45-sigils", label: "45 - Sigils", color: "bg-emerald-600"},
      %{num: "46", slug: "46-formatting", label: "46 - Formatting", color: "bg-teal-600"}
    ]},
    %{title: "Section 7: Structs & Protocols", katas: [
      %{num: "47", slug: "47-structs", label: "47 - Structs", color: "bg-emerald-400"},
      %{num: "48", slug: "48-struct-validation", label: "48 - Struct Validation", color: "bg-teal-400"},
      %{num: "49", slug: "49-protocols", label: "49 - Protocols", color: "bg-emerald-500"},
      %{num: "50", slug: "50-builtin-protocols", label: "50 - Built-in Protocols", color: "bg-teal-500"},
      %{num: "51", slug: "51-behaviours", label: "51 - Behaviours", color: "bg-emerald-600"},
      %{num: "52", slug: "52-polymorphism", label: "52 - Polymorphism", color: "bg-teal-600"},
      %{num: "53", slug: "53-module-attributes", label: "53 - Module Attributes", color: "bg-emerald-400"},
      %{num: "54", slug: "54-use-import", label: "54 - Use & Import", color: "bg-teal-400"}
    ]},
    %{title: "Section 8: Processes", katas: [
      %{num: "55", slug: "55-spawn-processes", label: "55 - Spawn & Processes", color: "bg-emerald-500"},
      %{num: "56", slug: "56-send-receive", label: "56 - Send & Receive", color: "bg-teal-500"},
      %{num: "57", slug: "57-process-links", label: "57 - Process Links", color: "bg-emerald-600"},
      %{num: "58", slug: "58-process-monitors", label: "58 - Process Monitors", color: "bg-teal-600"},
      %{num: "59", slug: "59-process-state", label: "59 - Process State Loop", color: "bg-emerald-400"},
      %{num: "60", slug: "60-trapping-exits", label: "60 - Trapping Exits", color: "bg-teal-400"},
      %{num: "61", slug: "61-task-module", label: "61 - Task Module", color: "bg-emerald-500"},
      %{num: "62", slug: "62-agent", label: "62 - Agent", color: "bg-teal-500"}
    ]},
    %{title: "Section 9: GenServer & OTP", katas: [
      %{num: "63", slug: "63-genserver-basics", label: "63 - GenServer Basics", color: "bg-emerald-600"},
      %{num: "64", slug: "64-call-vs-cast", label: "64 - Call vs Cast", color: "bg-teal-600"},
      %{num: "65", slug: "65-genserver-state", label: "65 - GenServer State", color: "bg-emerald-400"},
      %{num: "66", slug: "66-periodic-work", label: "66 - Periodic Work", color: "bg-teal-400"},
      %{num: "67", slug: "67-supervisor-basics", label: "67 - Supervisor Basics", color: "bg-emerald-500"},
      %{num: "68", slug: "68-dynamic-supervisors", label: "68 - Dynamic Supervisors", color: "bg-teal-500"},
      %{num: "69", slug: "69-supervision-trees", label: "69 - Supervision Trees", color: "bg-emerald-600"},
      %{num: "70", slug: "70-registry", label: "70 - Registry", color: "bg-teal-600"},
      %{num: "71", slug: "71-ets-tables", label: "71 - ETS Tables", color: "bg-emerald-400"}
    ]},
    %{title: "Section 10: Advanced", katas: [
      %{num: "72", slug: "72-quote-unquote", label: "72 - Quote & Unquote", color: "bg-emerald-500"},
      %{num: "73", slug: "73-macros", label: "73 - Macros", color: "bg-teal-500"},
      %{num: "74", slug: "74-application-config", label: "74 - Application Config", color: "bg-emerald-600"},
      %{num: "75", slug: "75-elixir-toolbox", label: "75 - The Elixir Toolbox", color: "bg-teal-600"}
    ]},
    %{title: "Section 11: Essentials", katas: [
      %{num: "76", slug: "76-io-file", label: "76 - IO & File Operations", color: "bg-emerald-500"},
      %{num: "77", slug: "77-erlang-interop", label: "77 - Erlang Interop", color: "bg-teal-500"},
      %{num: "78", slug: "78-exunit-basics", label: "78 - ExUnit Basics", color: "bg-emerald-600"},
      %{num: "79", slug: "79-date-time", label: "79 - Date & Time", color: "bg-teal-600"},
      %{num: "80", slug: "80-nested-access", label: "80 - Nested Data Access", color: "bg-emerald-400"},
      %{num: "81", slug: "81-custom-exceptions", label: "81 - Custom Exceptions", color: "bg-teal-400"},
      %{num: "82", slug: "82-debugging", label: "82 - Debugging Tools", color: "bg-emerald-500"},
      %{num: "83", slug: "83-nodes-distribution", label: "83 - Nodes & Distribution", color: "bg-teal-500"}
    ]}
  ]

  @doc """
  Renders the Elixir Katas layout with a dedicated sidebar.
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  def elixir_app(assigns) do
    assigns = assign(assigns, :sections, @elixir_kata_sections)
    current_kata_id = assigns[:kata_id]
    assigns = assign(assigns, :current_kata_id, current_kata_id)

    ~H"""
    <div class="flex h-full bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100 font-sans">
      <!-- Sidebar -->
      <div id="sidebar" class="w-64 flex-shrink-0 bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700 flex flex-col transition-all duration-300 ease-in-out" data-layout-source="elixir-app">
        <div class="h-16 flex items-center px-6 border-b border-gray-200 dark:border-gray-700">
          <span class="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-emerald-500 to-teal-600">
            Elixir Katas
          </span>
        </div>
        <div class="flex-1 overflow-y-auto p-4" phx-hook="ScrollPosition" data-scroll-key="elixir-sidebar-nav" id="elixir-sidebar-nav">
          <nav class="space-y-1">
            <a href="/" class="group flex items-center px-4 py-2 text-sm font-medium rounded-md bg-emerald-50 dark:bg-emerald-900/20 text-emerald-700 dark:text-emerald-300">
              <.icon name="hero-home" class="mr-3 h-5 w-5 text-emerald-600 dark:text-emerald-400" />
              Home
            </a>

            <%= for section <- @sections do %>
              <div class="mt-6">
                <h3 class="px-4 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                  {section.title}
                </h3>
                <div class="mt-2 space-y-1 pl-2">
                  <%= for kata <- section.katas do %>
                    <.link
                      navigate={"/elixir-katas/#{kata.slug}"}
                      class={[
                        "group flex items-center px-4 py-2 text-sm font-medium rounded-md",
                        if(kata.num == @current_kata_id,
                          do: "bg-emerald-50 dark:bg-emerald-900/20 text-emerald-700 dark:text-emerald-300 font-semibold",
                          else: "text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700/50 hover:text-gray-900 dark:hover:text-white"
                        )
                      ]}
                    >
                      <span class={["w-2 h-2 mr-3 rounded-full", kata.color]}></span>
                      {kata.label}
                    </.link>
                  <% end %>
                </div>
              </div>
            <% end %>
          </nav>
        </div>
        <div class="p-4 border-t border-gray-200 dark:border-gray-700">
          <div class="flex justify-center">
            <.theme_toggle />
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="flex-1 flex flex-col overflow-hidden relative">
        <header class="flex items-center justify-between h-16 px-6 bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
          <button
            id="elixir-sidebar-toggle"
            class="p-2 rounded-md hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
            onclick="toggleElixirSidebar()"
            aria-label="Toggle sidebar"
          >
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
            </svg>
          </button>
          <span class="text-lg font-bold md:hidden">Elixir Katas</span>
          <div class="w-10"></div>
        </header>

        <main class="flex-1 overflow-y-auto bg-gray-50 dark:bg-gray-900 p-4 sm:p-6 lg:p-8">
          <.flash_group flash={@flash} />
          <div class="mx-auto max-w-5xl">
            {@inner_content}
          </div>
        </main>
      </div>
    </div>
    <script>
      function toggleElixirSidebar() {
        const sidebar = document.getElementById('sidebar');
        const isHidden = sidebar.classList.contains('-ml-64');

        if (isHidden) {
          sidebar.classList.remove('-ml-64');
        } else {
          sidebar.classList.add('-ml-64');
        }
      }
    </script>
    """
  end

  @doc """
  Renders a simple layout for use cases without the katas sidebar.
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def use_case(assigns) do
    ~H"""
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="csrf-token" content={get_csrf_token()} />
        <.live_title suffix=" · Phoenix LiveView Katas">
          {assigns[:page_title] || "Phoenix LiveView Katas"}
        </.live_title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link phx-track-static rel="stylesheet" href={~p"/assets/css/app.css"} />
        <style>
          body { font-family: 'Inter', sans-serif; }
        </style>
        <script defer phx-track-static type="text/javascript" src={~p"/assets/js/app.js"}>
        </script>
        <script>
          (() => {
            const setTheme = (theme) => {
              if (theme === "system") {
                localStorage.removeItem("phx:theme");
                document.documentElement.removeAttribute("data-theme");
              } else {
                localStorage.setItem("phx:theme", theme);
                document.documentElement.setAttribute("data-theme", theme);
              }
            };
            if (!document.documentElement.hasAttribute("data-theme")) {
              setTheme(localStorage.getItem("phx:theme") || "system");
            }
            window.addEventListener("storage", (e) => e.key === "phx:theme" && setTheme(e.newValue || "system"));
            
            window.addEventListener("phx:set-theme", (e) => setTheme(e.target.dataset.phxTheme));
          })();
        </script>
      </head>
      <body>
        <div class="min-h-screen bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100">
          <!-- Header -->
          <header class="bg-white dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
              <div class="flex items-center space-x-4">
                <.link navigate="/" class="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-purple-600 to-pink-600">
                  Phoenix LiveView Katas
                </.link>
                <span class="text-gray-400">|</span>
                <.link navigate="/usecases" class="text-sm text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white">
                  ← Back to Use Cases
                </.link>
              </div>
              <div class="flex items-center space-x-4">
                <%= if assigns[:current_scope] && assigns.current_scope.user do %>
                  <span class="text-sm text-gray-600 dark:text-gray-300"><%= assigns.current_scope.user.email %></span>
                  <.link href="/users/log-out" method="delete" class="text-sm text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white">
                    Log out
                  </.link>
                <% else %>
                  <.link navigate="/users/log-in" class="text-sm text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white">
                    Log in
                  </.link>
                <% end %>
              </div>
            </div>
          </header>

          <!-- Main Content -->
          <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <.flash_group flash={@flash} />
            {@inner_content}
          </main>
        </div>
      </body>
    </html>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
