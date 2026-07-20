import { execFile } from "node:child_process";
import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import { promisify } from "node:util";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const execFileAsync = promisify(execFile);

const PI_THEME_NAME = "omarchy-colors";
const COLORS_TOML = path.join(os.homedir(), ".config/omarchy/current/theme/colors.toml");
const THEME_NAME_FILE = path.join(os.homedir(), ".config/omarchy/current/theme.name");

async function syncOmarchyPiTheme(): Promise<void> {
	try {
		await fs.promises.access(COLORS_TOML, fs.constants.F_OK);
	} catch {
		return;
	}

	try {
		await execFileAsync("omarchy-pi-theme", [], { timeout: 10_000 });
	} catch {
		// Theme sync is best-effort; pi can still use the last generated theme.
	}
}

function applyOmarchyTheme(ctx: ExtensionContext, silent = false): void {
	if (!ctx.hasUI) {
		return;
	}

	const result = ctx.ui.setTheme(PI_THEME_NAME);
	if (!result.success && !silent) {
		ctx.ui.notify(`Failed to apply Omarchy theme: ${result.error}`, "warning");
	}
}

export default function (pi: ExtensionAPI) {
	const watchers: fs.FSWatcher[] = [];
	let syncTimer: ReturnType<typeof setTimeout> | null = null;

	const scheduleSync = (ctx: ExtensionContext) => {
		if (syncTimer) {
			clearTimeout(syncTimer);
		}

		syncTimer = setTimeout(async () => {
			syncTimer = null;
			await syncOmarchyPiTheme();
			applyOmarchyTheme(ctx);
		}, 150);
	};

	pi.on("session_start", async (_event, ctx) => {
		await syncOmarchyPiTheme();
		applyOmarchyTheme(ctx, true);

		for (const watchTarget of [COLORS_TOML, THEME_NAME_FILE]) {
			if (!fs.existsSync(watchTarget)) {
				continue;
			}
			watchers.push(fs.watch(watchTarget, () => scheduleSync(ctx)));
		}
	});

	pi.on("session_shutdown", () => {
		if (syncTimer) {
			clearTimeout(syncTimer);
			syncTimer = null;
		}
		for (const watcher of watchers) {
			watcher.close();
		}
		watchers.length = 0;
	});
}
