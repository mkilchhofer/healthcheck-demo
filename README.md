# Demo App to play with Kubernetes health checks

The ruby sinatra app exposes two health endpoints:

* `/.well-known/ready`
* `/.well-known/live`

By default these endpoints return `200 OK` with some sample json body.

To simulate that the app in unhealthy, we can delete the files in `/tmp`:

* `/tmp/ready` affects API endpoint `/.well-known/ready`
* `/tmp/live` affects API endpoint `/.well-known/live`
