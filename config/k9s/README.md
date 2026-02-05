# k9s Configuration for GitOps Workflows

Custom k9s configuration optimized for **Flux2**, **Flux Tofu Controller**, and **KubeVela**.

## Prerequisites

Ensure the following CLI tools are installed:

```bash
# Flux CLI
brew install fluxcd/tap/flux

# Tofu Controller CLI
brew install weaveworks/tap/tfctl

# KubeVela CLI
brew install kubevela/tap/vela
```

## Installation

Symlink or copy the config files to your k9s config directory:

```bash
# macOS
ln -sf ~/Code/dotfiles/config/k9s/config.yaml ~/.config/k9s/config.yaml
ln -sf ~/Code/dotfiles/config/k9s/aliases.yaml ~/.config/k9s/aliases.yaml
ln -sf ~/Code/dotfiles/config/k9s/skins ~/.config/k9s/skins
```

## Quick Reference

### Aliases

Type these in k9s command mode (`:`) to quickly navigate resources:

#### Flux2 Resources

| Alias | Resource | Description |
|-------|----------|-------------|
| `:gr` | GitRepositories | Source git repositories |
| `:ks` or `:ku` | Kustomizations | Kustomize deployments |
| `:hr` | HelmReleases | Helm chart releases |
| `:helmRepo` | HelmRepositories | Helm chart repositories |
| `:helmChart` | HelmCharts | Helm charts |
| `:ociRepo` | OCIRepositories | OCI artifact sources |
| `:bucket` | Buckets | S3-compatible bucket sources |
| `:alert` | Alerts | Notification alerts |
| `:provider` | Providers | Notification providers |
| `:receiver` | Receivers | Webhook receivers |
| `:imgRepo` | ImageRepositories | Image scan repositories |
| `:imgPol` | ImagePolicies | Image update policies |
| `:imgAuto` | ImageUpdateAutomations | Automated image updates |

#### Tofu Controller

| Alias | Resource | Description |
|-------|----------|-------------|
| `:tf` or `:tofu` | Terraforms | Terraform/OpenTofu resources |

#### KubeVela

| Alias | Resource | Description |
|-------|----------|-------------|
| `:app` or `:vela` | Applications | Vela applications |
| `:compDef` | ComponentDefinitions | Component definitions |
| `:traitDef` | TraitDefinitions | Trait definitions |
| `:wfStep` | WorkflowStepDefinitions | Workflow step definitions |
| `:polDef` | PolicyDefinitions | Policy definitions |
| `:wf` | Workflows | Workflows |
| `:rev` | ApplicationRevisions | App revisions |
| `:rt` | ResourceTrackers | Resource trackers |

#### Core Kubernetes (Enhanced)

| Alias | Resource |
|-------|----------|
| `:p` | Pods |
| `:dp` | Deployments |
| `:ds` | DaemonSets |
| `:sts` | StatefulSets |
| `:svc` | Services |
| `:ing` | Ingresses |
| `:sec` | Secrets |
| `:cm` | ConfigMaps |
| `:pvc` | PersistentVolumeClaims |
| `:jo` | Jobs |
| `:cj` | CronJobs |
| `:ns` | Namespaces |
| `:no` | Nodes |
| `:ev` | Events |

## Keyboard Shortcuts (Plugins)

Select a resource and use these shortcuts:

### Flux2 Operations

| Shortcut | Action | Available On |
|----------|--------|--------------|
| `Shift-R` | **Reconcile** resource (with source) | GitRepos, Kustomizations, HelmReleases, HelmRepos, OCIRepos |
| `Shift-S` | **Suspend** resource | Kustomizations, HelmReleases |
| `Shift-U` | **Resume** resource | Kustomizations, HelmReleases |
| `Shift-T` | **Trace** dependencies | Kustomizations, HelmReleases, GitRepos |

### Tofu Controller Operations

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Shift-R` | **Reconcile** | Trigger reconciliation |
| `Shift-P` | **Show Plan** | Display pending Terraform plan |
| `Shift-A` | **Approve** | Approve pending plan |
| `Ctrl-P` | **Replan** | Force a new plan |
| `Ctrl-U` | **Unlock** | Force unlock state |

### KubeVela Operations

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Shift-V` | **Status** | Show application status |
| `Shift-T` | **Topology** | Show component tree |
| `Shift-D` | **Details** | Show detailed status |
| `Ctrl-R` | **Revisions** | List app revisions |

### General

| Shortcut | Action | Available On |
|----------|--------|--------------|
| `Shift-L` | **Tail Logs** | Pods |

## Common Workflows

### Flux: Check GitOps Status

```
:gr                    # View GitRepositories
:ks                    # View Kustomizations  
:hr                    # View HelmReleases
```

### Flux: Force Sync

1. Navigate to resource (`:ks`, `:hr`, or `:gr`)
2. Select the resource
3. Press `Shift-R` to reconcile

### Flux: Pause/Resume Deployments

1. Navigate to resource (`:ks` or `:hr`)
2. Select the resource
3. Press `Shift-S` to suspend
4. Press `Shift-U` to resume

### Tofu: Manage Infrastructure

```
:tf                    # View Terraform resources
```

1. Select a Terraform resource
2. Press `Shift-P` to view the plan
3. Press `Shift-A` to approve and apply

### Vela: Monitor Applications

```
:app                   # View applications
```

1. Select an application
2. Press `Shift-V` for status
3. Press `Shift-T` for topology tree

## Theme

Using **Catppuccin Mocha Transparent** theme. Available themes in `skins/`:

- `catppuccin-mocha.yaml` / `catppuccin-mocha-transparent.yaml`
- `catppuccin-macchiato.yaml` / `catppuccin-macchiato-transparent.yaml`
- `catppuccin-frappe.yaml` / `catppuccin-frappe-transparent.yaml`
- `catppuccin-latte.yaml` / `catppuccin-latte-transparent.yaml`

Change theme in `config.yaml`:

```yaml
ui:
  skin: catppuccin-mocha-transparent
```

## Tips

- Press `?` in k9s to see all available shortcuts
- Press `/` to filter resources
- Press `Ctrl-A` to toggle all namespaces
- Press `Esc` to go back
- Press `:` to enter command mode

## Troubleshooting

### Plugin not working?

1. Ensure CLI tool is installed (`flux`, `tfctl`, `vela`)
2. Check tool is in your PATH
3. Verify cluster connectivity

### Alias not found?

The CRD might not be installed in your cluster. Install the controller first:

```bash
# Flux
flux install

# Tofu Controller
kubectl apply -f https://raw.githubusercontent.com/flux-iac/tofu-controller/main/docs/release.yaml

# KubeVela
vela install
```
