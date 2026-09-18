// Sync the herdr tab label with the opencode session title. opencode's own
// terminal title carries pane status (peon-ping), not the session name, so
// the tab is renamed directly from session.updated events instead.
import type { Plugin } from "@opencode-ai/plugin"

const HERDR_TAB_TITLE = "@herdrTabTitle@"
const PLACEHOLDER_TITLE = /^(New session|Child session) - \d{4}-\d{2}-\d{2}T/

export const HerdrTabTitlePlugin: Plugin = async ({ $ }) => {
  let lastTitle = ""

  return {
    event: async ({ event }) => {
      if (event.type !== "session.updated") return
      const { title, parentID } = event.properties.info
      if (parentID || PLACEHOLDER_TITLE.test(title) || title === lastTitle) return
      lastTitle = title
      await $`${HERDR_TAB_TITLE} ${title}`.quiet().nothrow()
    },
  }
}
