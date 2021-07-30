ldcv = new ldcover root: '.ldcv'
ldf = new ldfile root: \input, type: \text, ldcv: ldcv
ldf.on \load, -> textarea.value = it.map(-> it.result).join(\\n)
