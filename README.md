# Demo App to play with Kubernetes health checks

The ruby sinatra app exposes two health endpoints:

* `/health/ready`
* `/health/live`

By default these endpoints return `200 OK` with a sample JSON body.

To simulate that the app in unhealthy, we can delete the files in `/tmp`:

* `/tmp/ready` affects API endpoint `/health/ready`
* `/tmp/live` affects API endpoint `/health/live`

## Additional endpoints

* `/` returns a simple `Hello world\n` (for curl and webbrowsers)
* `/env` returns all environment variables as JSON
