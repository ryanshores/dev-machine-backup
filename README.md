# dev-machine-backup
Backup you development setup. 

## Loading plist
Load it with `launchctl load ~/Developer/ryanshores/dev-machine-backup/config/dev-machine-snapshot.plist`.

---

### Checking the status
show: `launchctl list | grep dev-machine-snapshot`
kickstart: `launchctl kickstart -k "gui/$UID/com.ryanshores.dev-machine-snapshot"`
Look for things like last exit code, state, and any throttling/backoff info.
logs: `tail -n 200 -f /tmp/dev-machine-snapshot.log /tmp/dev-machine-snapshot.err`

## What Lives in iCloud's `dev-state/`
```
dev-state/
├── Brewfile          # full brew state, restorable
├── repos.tsv         # origin URLs + local paths + dirty status
├── restore.sh        # entry point for restoration
└── scripts/          # restore worker scripts
    ├── restore-brew.sh
    └── restore-repos.sh
```

### repo snapshot
Creates a restorable list of all the origins in you ~/Development folder

### brew snapshot
Creates a restorable list of all the packges you have installed with Brew


