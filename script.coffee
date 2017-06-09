_ = require('lodash')
csvjson = require('csvjson')
dirname = require('path').dirname
fs = require('fs')
mkdirp = require('mkdirp')
moment = require('moment')


parseData = (data)->
	a = csvjson.toObject data, { delimiter:',', quote:'"' }
	a = _.chain a
		.filter { Bookshelves:'to-read' }
		.sortBy 'Author l-f'
		.value()

	list = []
	_.forEach a, (obj)->
		list.push {
			title: obj.Title
			author: obj['Author l-f']
			isbn: obj.ISBN
			isbn13: obj.ISBN13
		}

	console.log list[0]

	saveLoc = process.argv[3] or "./bin/to_read_#{ moment().format('YYYY-MM-DD') }.csv"
	out = csvjson.toCSV list, { delimiter:',', wrap:false }
	mkdirp dirname(saveLoc), (err)->
		return console.warn err if err

		fs.writeFile saveLoc, out, (err2)->
			return console.warn err2 if err2
			console.log "file #{ saveLoc } saved"


path = process.argv[2] or ''
data = fs.readFileSync path, { encoding:'utf8' }


parseData data
