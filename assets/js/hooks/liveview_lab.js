// Hooks used by the LiveView Lab katas (141-153).
// Copied from phoenix-liveview-tutorial assets/js/app.js; keep in sync with
// `mix liveview_lab.sync`, which reports when the upstream hooks change.
//
// Hooks that call pushEvent() send the event to the kata host LiveView,
// which forwards it to the kata component as update(%{event: _, params: _}).

export const LiveviewLabHooks = {
  // Auto-scroll container to bottom when content changes
  ScrollBottom: {
    mounted() { this.scrollToBottom() },
    updated() { this.scrollToBottom() },
    scrollToBottom() {
      this.el.scrollTop = this.el.scrollHeight
    }
  },

  // Copy text to clipboard
  Clipboard: {
    mounted() {
      this.el.addEventListener("click", () => {
        const text = this.el.dataset.clipboardText
        navigator.clipboard.writeText(text).then(() => {
          const original = this.el.innerText
          this.el.innerText = "Copied!"
          setTimeout(() => this.el.innerText = original, 1500)
        })
      })
    }
  },

  // Convert UTC timestamp to local time
  LocalTime: {
    mounted() { this.updateTime() },
    updated() { this.updateTime() },
    updateTime() {
      const utc = this.el.dataset.utc
      if (utc) {
        const local = new Date(utc).toLocaleString()
        this.el.innerText = `UTC: ${utc} → Local: ${local}`
      }
    }
  },

  // Capture key events and push to server
  KeyListener: {
    mounted() {
      this.el.addEventListener("keydown", (e) => {
        this.pushEvent("key_pressed", { key: e.key })
        this.el.innerText = `Last key: ${e.key}`
      })
    }
  },

  // Receive server-pushed events
  ConfettiReceiver: {
    mounted() {
      this.handleEvent("confetti", ({ message, timestamp }) => {
        this.el.innerText = `${message} (server time: ${timestamp})`
        this.el.classList.add("animate-pulse")
        setTimeout(() => this.el.classList.remove("animate-pulse"), 2000)
      })
    }
  }
}
