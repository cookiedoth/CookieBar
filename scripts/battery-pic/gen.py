from PIL import Image, ImageDraw
import math

WIDTH = 2

class ImageGenerator:
	def __init__(self, size, paddingLR, paddingU, paddingD, capWidth, capHeight, filledIn, isCharging):
		self.size = size
		self.paddingLR = paddingLR
		self.paddingU = paddingU
		self.paddingD = paddingD
		self.paddingLR = paddingLR
		self.capHeight = capHeight
		self.capWidth = capWidth
		self.filledIn = filledIn
		self.isCharging = isCharging

	def generate(self):
		self.img = Image.new(mode = 'RGBA', size = (self.size, self.size))
		self.pixels = self.img.load()
		draw = ImageDraw.Draw(self.img)

		mainRect = (self.paddingLR, self.paddingU + self.capHeight, self.size - self.paddingLR, self.size - self.paddingD)
		draw.rectangle(mainRect, outline=(255, 255, 255, 255), width=WIDTH)

		cap = (self.size / 2 - self.capWidth / 2, self.paddingU, self.size / 2 + self.capWidth / 2, self.paddingU + self.capHeight)
		draw.rectangle(cap, outline=(255, 255, 255, 255), width=WIDTH)

		total_h = mainRect[3] - mainRect[1] - 2 * WIDTH + 1
		frac = self.filledIn / total_h
		color = (int(round(255 * min(1, 2 - 2 * frac))), int(round(255 * min(1, 2 * frac))), 0, 255)
		if self.filledIn > 0:
			draw.rectangle((mainRect[0] + WIDTH, mainRect[3] - self.filledIn - WIDTH + 1, mainRect[2] - WIDTH, mainRect[3] - WIDTH), fill=color)

		mid_y = int(round(mainRect[1] * 0.5 + mainRect[3] * 0.5))
		high_y = int(round(mainRect[1] * 0.8 + mainRect[3] * 0.2))
		low_y = int(round(mainRect[1] * 0.2 + mainRect[3] * 0.8))
		left_x0 = int(round(mainRect[0] * 0.6 + mainRect[2] * 0.4))
		right_x0 = int(round(mainRect[0] * 0.4 + mainRect[2] * 0.6))
		left_x = int(round(mainRect[0] * 0.7 + mainRect[2] * 0.3))
		right_x = int(round(mainRect[0] * 0.3 + mainRect[2] * 0.7))

		if self.isCharging:
			draw.line(
				[(right_x0, high_y),
				(left_x, mid_y),
				(right_x, mid_y),
				(left_x0, low_y)],
				fill=(255, 255, 255, 255), width=3)

		return self.img

if __name__ == '__main__':
	imgGen = ImageGenerator(60, 17, 5, 5, 10, 7, 40, True)
	img = imgGen.generate()
	img.show()
