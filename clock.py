#!/usr/bin/python
import time
import signal
import argparse

# default values
color = 'blue'
char = '▀ ' #█◊:LE◢┏━└▀▄▌◙∏°ο○●
redraw = 10
offset = (2, 1)
zoom = 1
background = 'none'


################################################################################
# data
################################################################################
font = {'0': [[1,1,1], [1,0,1], [1,0,1], [1,0,1], [1,1,1]],
        '1': [[0,0,1], [0,0,1], [0,0,1], [0,0,1], [0,0,1]],
        '2': [[1,1,1], [0,0,1], [1,1,1], [1,0,0], [1,1,1]],
        '3': [[1,1,1], [0,0,1], [1,1,1], [0,0,1], [1,1,1]],
        '4': [[1,0,1], [1,0,1], [1,1,1], [0,0,1], [0,0,1]],
        '5': [[1,1,1], [1,0,0], [1,1,1], [0,0,1], [1,1,1]],
        '6': [[1,1,1], [1,0,0], [1,1,1], [1,0,1], [1,1,1]],
        '7': [[1,1,1], [0,0,1], [0,0,1], [0,0,1], [0,0,1]],
        '8': [[1,1,1], [1,0,1], [1,1,1], [1,0,1], [1,1,1]],
        '9': [[1,1,1], [1,0,1], [1,1,1], [0,0,1], [1,1,1]],
        ':': [[0], [1], [0], [1], [0]]
       }

colors = {'black' : '30',
          'red': '31',
          'green' : '32',
          'yellow' : '33',
          'blue' : '34',
          'magenta': '35',
          'cyan' : '36',
          'white' : '37',
          'none' : '0',
         }
for i in range(256):
    colors[str(i)] = '38;5;%d' %i


################################################################################
# drawing functions
################################################################################
def clear():
    print('\033[2J')

def hideCursor():
    print('\033[?25l')

def showCursor():
    print('\033[?25h')

def setAt(x, y, char=char):
    print('\033[%d;%dH%s' %(y + 1, x + 1, char))

def setColor(color, bg=False):
    if bg and color == 'none': return
    print('\033[%sm' %(colors[color].replace('3', '4', bg)))

def drawNumberAt(x, y, num):
    for l, line in enumerate(font[num]):
        i = 0
        for c, col in enumerate(line):
            if col:
                for z in range(zoom*2):
                    for zz in range(zoom):
                        setAt(x + c*2*zoom + z, y + l*zoom + zz,
                                char[i%len(char)])
                    i += 1
            else:
                i += zoom*2

def drawString(string, x = 0, y = 0):
    for char in string:
        drawNumberAt(x, y, char)
        x += (len(font[char][-1]) + 1)*zoom*2

def drawTime(x = 0, y = 0):
    drawString(time.strftime('%H:%M'), x, y)


################################################################################
# argument parser
################################################################################
def posInt(i):
    ival = int(i)
    if ival < 0:
        raise argparse.ArgumentTypeError("invalid positive int value: '%d'" %i)
    return ival

parser = argparse.ArgumentParser(
        prog='clock.py',
        description='Draw a digital clock in the terminal.',
        epilog='''COLOR may be a color name [black, red, green, yellow, blue,
        magenta, cyan, white, none] or an integer [0-255]. If DELAY is 0 the
        clock is pretty much useless since it is never redrawn. OFFSET must be
        0 or greater.''')

parser.add_argument('-v', '--version',
        action='version',
        version='clock.py v1.0')
parser.add_argument('-C', '--color',
        help='set the digits\' color',
        choices = colors.keys(),
        metavar='COLOR')
parser.add_argument('-c', '--char',
        help='set the character(s) to use for drawing')
parser.add_argument('-r', '--redraw',
        help='set time to wait between redraws in seconds',
        metavar='DELAY',
        type=posInt)
parser.add_argument('-x',
        help='x offset (from left)',
        metavar='OFFSET',
        type=posInt)
parser.add_argument('-y',
        help='y offset (from top)',
        metavar='OFFSET',
        type=posInt)
parser.add_argument('-z', '--zoom',
        help='display digits X times bigger',
        metavar='X',
        type=posInt)
parser.add_argument('-b', '--background',
        help='set background color',
        metavar='COLOR',
        choices = colors.keys())

args = parser.parse_args()

color = args.color or color
char = args.char or char
redraw = args.redraw or redraw
offset = ((args.x == None) and offset[0] or args.x,
        (args.y == None) and offset[1] or args.y)
zoom = args.zoom or zoom
background = args.background or background


################################################################################
# main
################################################################################
def onTerm(sig, frame):
    global running
    running = False

hideCursor()
setColor(color)
setColor(background, True)

running = True
signal.signal(signal.SIGTERM, onTerm)
signal.signal(signal.SIGINT, onTerm)
while running:
    clear()
    drawTime(*offset)
    time.sleep(redraw)

setColor('none')
showCursor()
