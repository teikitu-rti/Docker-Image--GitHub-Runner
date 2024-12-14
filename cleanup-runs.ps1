# PARAMETER LIST FOR SCRIPT
Param(
    [Parameter(HelpMessage = "REPO")]
    [string]$REPO = "teikitu"
)

# Set your GitHub token and repository URL
$repositoryUrl = 'https://api.github.com/repos/teikitu-rti/$REPO'

# Get the list of workflow runs
$workflowRuns = Invoke-WebRequest -Uri ($repositoryUrl + '/actions/runs') -Headers @{Authorization = "Bearer $env:GH_TOKEN"} -Method Get

# Filter active runs (queued or in_progress) and cancel them
$workflowObjects = $workflowRuns.Content | ConvertFrom-Json
$activeRuns = $workflowObjects.workflow_runs | Where-Object {$_.status -eq 'queued' -or $_.status -eq 'in_progress'}
foreach ($activeRun in $activeRuns) {
    gh run cancel $activeRun.id
}
