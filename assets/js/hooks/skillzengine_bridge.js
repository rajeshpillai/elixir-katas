export const SkillzEngineBridge = {
  mounted() {
    // 1. Capture parameters from URL and save to sessionStorage
    const urlParams = new URLSearchParams(window.location.search);
    const se_api = urlParams.get("se_api") || sessionStorage.getItem("se_api");
    const se_token = urlParams.get("se_token") || sessionStorage.getItem("se_token");
    const se_path = urlParams.get("se_path") || sessionStorage.getItem("se_path");

    if (urlParams.get("se_api")) sessionStorage.setItem("se_api", urlParams.get("se_api"));
    if (urlParams.get("se_token")) sessionStorage.setItem("se_token", urlParams.get("se_token"));
    if (urlParams.get("se_path")) sessionStorage.setItem("se_path", urlParams.get("se_path"));

    // 2. Listen to complete-kata event pushed from the server
    this.handleEvent("kata_completed", ({ kata_id }) => {
      // Send message to parent frame
      if (window.parent && window.parent !== window) {
        window.parent.postMessage({ type: "KATA_COMPLETED", kataId: kata_id }, "*");
      }

      // Also POST completion to parent API if params are available
      if (se_api && se_token && se_path) {
        fetch(`${se_api}/api/learning/progress`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "Authorization": `Bearer ${se_token}`
          },
          body: JSON.stringify({
            pathId: se_path,
            kataId: kata_id
          })
        })
        .then(res => res.json())
        .then(data => {
          console.log("Successfully synchronized progress with SkillzEngine:", data);
        })
        .catch(err => {
          console.error("Failed to synchronize progress with SkillzEngine:", err);
        });
      }
    });
  }
}
