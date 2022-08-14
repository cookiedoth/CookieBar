from PIL import Image, ImageDraw
import math

def sqr(x):
	return x * x

class ImageGenerator:
	def __init__(self, size, base_y, inner_radius, outer_radius, arrow_len, arrow_radius, frac):
		self.size = size
		self.base_y = base_y
		self.inner_radius = inner_radius
		self.outer_radius = outer_radius
		self.arrow_len = arrow_len
		self.arrow_radius = arrow_radius
		self.frac = frac

	def get_distance(self, x, y):
		return math.sqrt(sqr(x - self.size / 2) + sqr(y - self.base_y))

	def get_frac(self, x, y):
		dx = x - self.size / 2
		dy = y - self.base_y
		ang = math.atan2(dy, dx)
		# want pi..2*pi range
		if (ang < math.pi / 2):
			ang += 2 * math.pi
		if (ang > math.pi * 2.5):
			ang -= 2 * math.pi
		return (ang - math.pi) / math.pi

	def get_color(self, frac):
		bright = frac < self.frac
		if frac < 1 / 3:
			return (255 if bright else 100, 0, 0, 255)
		elif frac < 2 / 3:
			return (255 if bright else 100, 255 if bright else 100, 0, 255)
		else:
			return (0, 255 if bright else 100, 0, 255)

	def rotate(self, x, y, ang):
		return math.cos(ang) * x - math.sin(ang) * y, math.sin(ang) * x + math.cos(ang) * y

	def generate(self):
		self.img = Image.new(mode = 'RGBA', size = (self.size, self.size))
		self.pixels = self.img.load()
		for x in range(self.size):
			for y in range(self.base_y + 1):
				dst = self.get_distance(x, y)
				if dst >= self.inner_radius and dst <= self.outer_radius:
					self.pixels[x, y] = self.get_color(self.get_frac(x, y))

		arrow_color = (200, 0, 200, 255)
		draw = ImageDraw.Draw(self.img)
		draw.ellipse((
			self.size / 2 - self.arrow_radius,
			self.base_y - self.arrow_radius,
			self.size / 2 + self.arrow_radius,
			self.base_y + self.arrow_radius), fill=arrow_color)

		ang0 = math.pi + self.frac * math.pi
		theta = math.acos(self.arrow_radius / self.arrow_len)
		dx1, dy1 = math.cos(ang0) * self.arrow_len, math.sin(ang0) * self.arrow_len
		dx2, dy2 = self.rotate(math.cos(ang0) * self.arrow_radius, math.sin(ang0) * self.arrow_radius, theta)
		dx3, dy3 = self.rotate(math.cos(ang0) * self.arrow_radius, math.sin(ang0) * self.arrow_radius, -theta)
		draw.polygon([
			(self.size / 2 + dx1, self.base_y + dy1),
			(self.size / 2 + dx2, self.base_y + dy2),
			(self.size / 2 + dx3, self.base_y + dy3)], fill=arrow_color)

		return self.img

if __name__ == '__main__':
	imgGen = ImageGenerator(100, 75, 25, 40, 15, 5, 1)
	img = imgGen.generate()
	img.show()
