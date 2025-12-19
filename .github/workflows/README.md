# Branching & CI/CD Workflow

## Branches

* **`dev/*`**
  Used for development. All work starts here.

* **`develop`**
  Integration branch.

  * ❌ No direct pushes
  * ✅ Only merged via Pull Requests
  * ✅ Requires 1 approval
  * ✅ Requires CI to pass
  * ✅ Must be up to date before merging

* **`main`**
  Stable branch.

  * ❌ No direct pushes
  * ✅ Updated automatically from `develop` via CI

---

## CI/CD Pipelines

### 1) `check pr`

**Trigger:** Pull Request → `develop`
**Purpose:** Validate changes before merging

What it does:

* Builds Docker containers
* Starts Rails + MariaDB
* Prepares test database
* Runs `bin/rails test`

➡️ **PRs cannot be merged if this fails**

---

### 2) `merge develop into main`

**Trigger:** Merge/push to `develop`
**Purpose:** Keep `main` in sync with validated code

What it does:

* Merges `develop` into `main`
* Pushes using a deploy key
* Respects branch protection rules

---

## Workflow Summary

```text
dev/* → PR on develop
            ↓
        check pr (CI)
            ↓
        merge develop
            ↓
        CI auto-merges → main
```

This setup ensures:

* Only tested code reaches `develop`
* `main` always stays stable
* No manual or unsafe pushes
