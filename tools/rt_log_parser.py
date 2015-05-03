import re, datetime

nginx_log = "rt_collected.log"
endpoint_url = "/app/collect"

block = []
quote = []
seq = []

months = {1:'Jan', 2:'Feb', 3:'Mar', 4:'Apr', 5:'May', 6:'Jun', 7:'Jul', 8:'Aug', 9:'Sep', 10:'Oct', 11:'Nov', 12:'Dec'}

def uniq(seq):
	seen = set() 
	seen_add = seen.add 
	return [ x for x in seq if not (x in seen or seen_add(x))]


for i in open(nginx_log, 'r'):
	if endpoint_url in i:
		date = re.search('\[([^\]]+)\]', i)
		request = re.search('"([^"]+)"', i)
		
		quote.append(date.group(0).split(':')[0][1:].replace('/','-'))
		for i in request.group(0)[18:][:-9].split('&'): quote.append(i.split('=')[1])

		block.append(quote)
		quote = []


for month in range(1,13):
	for element in block:
		if months[month] in element[0]:
			seq.append(element[1])
	if len(uniq(seq)) != 0:
		print months[month], len(uniq(seq))
	seq = []

	for day in range(1,32):
		day = '%02d' % (day,)
		for element in block:
			if day+'-'+months[month] in element[0]:
				seq.append(element[1])
		if len(uniq(seq)) != 0:
			print day, len(uniq(seq))
		seq = []