export const SkillzEngineBridge = {
  mounted() {
    // 1. Capture parameters from URL and save to sessionStorage
    const urlParams = new URLSearchParams(window.location.search);
    const se_path = urlParams.get("se_path") || sessionStorage.getItem("se_path");

    if (urlParams.get("se_path")) sessionStorage.setItem("se_path", urlParams.get("se_path"));

    // 2. Listen to complete-kata event pushed from LiveView server
    this.handleEvent("kata_completed", ({ kata_id }) => {
      // Send message to parent frame over postMessage
      if (window.parent && window.parent !== window) {
        console.log("[SkillzEngine Bridge] Posting KATA_COMPLETED to parent window:", kata_id);
        window.parent.postMessage({ type: "KATA_COMPLETED", kataId: kata_id, pathId: se_path }, "*");
      }
    });

    // 3. Listen to progress messages from parent window
    window.addEventListener("message", (event) => {
      let data = event.data;
      if (typeof data === "string") {
        try { data = JSON.parse(data); } catch (e) {}
      }
      if (data && data.type === "KATA_PROGRESS_DATA" && Array.isArray(data.completed_katas)) {
        this.pushEvent("sync_remote_progress", { completed_katas: data.completed_katas });
      }
    });

    // Request initial progress from parent window
    if (window.parent && window.parent !== window) {
      window.parent.postMessage({ type: "GET_KATA_PROGRESS", pathId: se_path }, "*");
    }
  }
}
