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

## Usage

### Start the image with plain docker

```bash
$ docker run -d --rm -p 9292:9292 docker.io/kicm/healthcheck-demo
```

Open your browser and play with the different endpoints:
* http://localhost:9292/
* http://localhost:9292/env
* http://localhost:9292/health/live
* http://localhost:9292/health/ready

### Example deployment in Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: healthcheck-demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: healthcheck-demo
  template:
    metadata:
      labels:
        app: healthcheck-demo
    spec:
      containers:
      - name: app
        image: docker.io/kicm/healthcheck-demo
        ports:
        - containerPort: 9292
          name: http
        env:
          - name: FOO
            value: bar
          - name: HELLO
            value: world
        livenessProbe:
          httpGet:
            port: http
            path: /health/live
          periodSeconds: 5
        readinessProbe:
          httpGet:
            port: http
            path: /health/ready
          periodSeconds: 1
```

Now you can play with these endpoints. Let's make one Pod "not ready":

```bash
$ kubectl exec -ti healthcheck-demo-745554966d-f9jvz bash
www-data@healthcheck-demo-745554966d-f9jvz:/$ rm /tmp/ready
```

After 3 seconds you see that this Pod is not ready anymore (`0/1`):

```bash
$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
healthcheck-demo-745554966d-f9jvz   0/1     Running   0          4m45s
healthcheck-demo-745554966d-ghxqk   1/1     Running   0          4m39s
healthcheck-demo-745554966d-xwhp5   1/1     Running   0          4m42s
```

Let's make it unhealthy now: delete the file `/tmp/live` inside the Pod:

```bash
$ kubectl exec -ti healthcheck-demo-745554966d-f9jvz bash
www-data@healthcheck-demo-745554966d-f9jvz:/$ rm /tmp/live
```

After around 25 seconds, Kubernetes restarts this Pod:

```bash
$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
healthcheck-demo-745554966d-f9jvz   1/1     Running   1          6m52s
healthcheck-demo-745554966d-ghxqk   1/1     Running   0          6m46s
healthcheck-demo-745554966d-xwhp5   1/1     Running   0          6m49s
```
