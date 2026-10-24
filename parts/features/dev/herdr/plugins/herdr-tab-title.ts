// Sync the herdr tab label with the title of the session shown in this pane.
// opencode's own terminal title carries pane status (peon-ping), not the
// session name, so the tab is renamed directly. opencode 2.x shares one server
// across panes, so this is a TUI plugin: only the TUI knows its pane.
import { execFile } from "node:child_process"
import type { Plugin } from "@opencode/plugin/tui"

const HERDR_TAB_TITLE = "@herdrTabTitle@"
const PLACEHOLDER_TITLE = /^(New session|Child session) - \d{4}-\d{2}-\d{2}T/
// The TUI cache applies session.renamed only after re-syncing the session, so
// poll the cache instead of racing that event with a stale read.
const POLL_INTERVAL_MS = 500

export default {
  id: "herdr.tab-title",
  setup: (api) => {
    if (process.env.HERDR_ENV !== "1") return
    const poll = setInterval(tabTitleSync(api, renameTab), POLL_INTERVAL_MS)
    return () => clearInterval(poll)
  },
} satisfies Plugin.Definition

export function tabTitleSync(api: Plugin.Context, rename: (title: string) => void) {
  let lastTitle = ""
  return () => {
    const title = routedRootTitle(api)
    if (!title || PLACEHOLDER_TITLE.test(title) || title === lastTitle) return
    lastTitle = title
    rename(title)
  }
}

function routedRootTitle(api: Plugin.Context) {
  const route = api.ui.router.current()
  if (route.type !== "session") return
  return api.data.session.get(api.data.session.root(route.sessionID))?.title
}

function renameTab(title: string) {
  execFile(HERDR_TAB_TITLE, [title], () => {})
}
