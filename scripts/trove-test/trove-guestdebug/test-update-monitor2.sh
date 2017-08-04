token=$1
curl -X POST  http://127.0.0.1:8779/v1.0/dbdd1e7b27884c39ae19194b587a83c5/instances/12bcff0e-6b90-4bf3-91eb-4f05d3c2e894/monitor -H "User-Agent: trove keystoneauth1/2.18.0 python-requests/2.14.2 CPython/2.7.5" -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token:$token" -d '{"update_monitor": {"server":"10.0.200.83"}}'
