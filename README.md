# dev-machine-backup
Backup you development setup. 

## Loading plist
Load it with `launchctl load ~/Developer/dev-machine-snapshot/com.you.dev-machine-snapshot.plist`.

---

## What Lives in iCloud's `dev-state/`
```
dev-state/
├── Brewfile          # full brew state, restorable
├── repos.tsv         # origin URLs + local paths + dirty status
└── restore.sh        # optional: reads repos.tsv and re-clones

### repo snapshot
Creates a restorable list of all the origins in you ~/Development folder

### brew snapshot
Creates a restorable list of all the packges you have installed with Brew


