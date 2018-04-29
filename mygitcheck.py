from colored import fg, bg, attr
from colored import colored as cobj

# In developpement mode, for use
# python ~/mygitcheck.py
# python ~/mygitcheck.py | grep magenta

defaultcolor = attr('reset') + fg('black')
colortheme = {
    'default': defaultcolor,
    'prjchanged': attr('reset') + attr('bold') + fg('light_red'),
    'prjremote': attr('reverse') + fg('deep_pink_1a'),
    'prjname': attr('reset') + attr('bold') + fg('black'),
    'reponame': attr('reset') + attr('bold') + fg('light_goldenrod_2b'),
    'branchname': defaultcolor,
    'fileupdated': attr('reset') + attr('bold') + fg('green'),
    'remoteto': attr('reset') + attr('bold') + fg('deep_sky_blue_3b'),
    'committo': attr('reset') + attr('bold') + fg('violet'),
    'commitinfo': attr('reset') + attr('bold') + fg('deep_sky_blue_3b'),
    'commitstate': attr('reset') + fg('light_blue'),
    'bell': "\a",
    'reset': "\033[2J\033[H"
}


def searchKeyByValue(search):
    """Search keyname by value"""
    c = cobj(0)
    for key, value in c.paint.iteritems():
        if value == str(search):
            return key

def searchMaxColorName():
    """Search Max length colorname"""
    c = cobj(0)
    maxi = 0
    for key, value in c.paint.iteritems():
        lencolor = len(str(key))
        maxi = max(lencolor, maxi)

    print "Lencolor: %s" % maxi

if __name__ == "__main__":
    #searchMaxColorName()
    for idx in range(0, 255):
        print "%s%19s %s%s%s%s" % (
            attr('reset') + fg(idx),
            searchKeyByValue(idx),
            'Normal',
            attr('reset') + fg(idx) + attr('bold') + 'Bold',
            attr('reset') + fg(idx) + attr('underlined') + 'Underline',
            attr('reset') + fg(idx) + attr('reverse') + 'Reverse',
)
