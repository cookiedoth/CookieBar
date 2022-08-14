import gen

FREQ=60
for i in range(FREQ + 1):
	imgGen = gen.ImageGenerator(100, 75, 25, 40, 15, 5, i / FREQ)
	img = imgGen.generate()
	img.save(f'assets/speed{i}.png')
	print('done', i)
