nginx_log = "/var/log/nginx/access.log"
endpoint_url = "/app/collect"

with open('rt_collected.log', 'a') as storage:
	for i in open(nginx_log,'r'):
		if endpoint_url in i:
			if i not in storage:
				storage.write(i)








