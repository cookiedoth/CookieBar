import gen

FREQ=40
for i in range(FREQ + 1):
	imgGen = gen.ImageGenerator(60, 17, 5, 5, 10, 7, i, False)
	img = imgGen.generate()
	img.save(f'assets/battery{i}.png')
	imgGen = gen.ImageGenerator(60, 17, 5, 5, 10, 7, i, True)
	img = imgGen.generate()
	img.save(f'assets/battery{i}_charging.png')
	print('done', i)
