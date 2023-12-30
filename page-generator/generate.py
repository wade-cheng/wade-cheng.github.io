# TODO wait instead of going through every single file, you could just do smth like os.run("cp *.js").
# figure out how that works

from os import listdir
from typing import List
import sys

"""generate.py
when ran, takes all html files in this directory and formats them with stuff and puts that in the upper directory
"""


def doubleIndent(text: str) -> str:
    """formats the input text with four spaces (two indents of two spaces)"""
    return text.replace("\n", "\n    ")


def shouldExport(file: str) -> bool:
    """should this file be exported? returns true if """
    blacklist = {
        "build.bat",
        "generate.py",
        "README.md",
    }
    whitelist = {  # WARNING: SHOULD WHITELIST ALL FILES WITHOUT EXTENSIONS, OR ERROR
        "CNAME",
    }
    if file in whitelist:  # whitelist has prio
        return True
    
    return "." in file and file not in blacklist


def getFilesRecur(filepath: str):
    """
    YOOOO i think i can make this recursive
    returns a list of strings that are filenames, recursively from filepath
    first call should be "."
    """

    items: List[str] = listdir(filepath)

    ans = []

    for item in items:
        if shouldExport(item):
            ans.append(f"{filepath}/{item}")
        elif "." not in item:  # if all extension-less files are whitelisted, this should rep all dirs
            ans += getFilesRecur(item)

    return ans


def formatText(text: str, file: str) -> str:
    """
    formats a .css, .js, or .html file to be written.
    css and js files are just copied over but html files need the header and footers.
    """
    ABOVE: str = """<!DOCTYPE html>

<html>
  <head>
    <meta charset="utf-8">
    <title>wade!</title>
    <meta name="description" content="a personal web site">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/style.css" rel="stylesheet" type="text/css">
    <link rel="icon" type="image/png" sizes="16x16" href="/assets/heart16x16.png">
  </head>

  <body>
  <div id=site-container>
    <script src="/darkmode.js"></script>
  
    <div class="left-spacer"></div>

    <nav>
      <a href="/index.html">home</a>
      <a href="/blog.html">blog</a>
      <a href="/projects.html">projects</a>
      <a class="settings-btn" href="/settings.html">settings</a>
      <img src="/assets/nighttime.png">
    </nav>

    """
# TODO: above: wrap nav in <header> but not the <img>. will need to update style.scss # wait why lol
    BELOW: str = """
  </div>
  </body>
</html>"""

    if len(file) >= 5:
        if file[-5:] == ".html":
            return ABOVE + doubleIndent(text) + BELOW
    return text

        
def genFiles():
    """generate all files"""
    filesToExport = getFilesRecur(".")

    print(f"detected files: {filesToExport}\n")

    # generate files in parent (/doc) directory
    for file in filesToExport:
        print(f"Working on output file ../{file}")

        text: str = ""

        # save the text from inputFile into string variable text
        with open(file, "r") as inputFile:
            text = inputFile.read()
            print(f"  Input text ./{file} read")

        # write into output file
        with open(f"../docs/{file}", "w") as outputFile:
            outputFile.write(formatText(text, file))

            print(f"  Text in output file ../docs/{file} replaced")

        print("  Done")

    print("Done")
    
    
def genFile(file: str):
    """generate from filepath file in parent (/doc) directory"""
    file = file.replace("\\", "/")
    print("file is now",file)
    
    print(f"Working on output file ../{file}")

    text: str = ""

    # save the text from inputFile into string variable text
    with open(file, "r") as inputFile:
        text = inputFile.read()
        print(f"  Input text ./{file} read")

    # write into output file
    with open(f"../docs/{file}", "w") as outputFile:
        outputFile.write(formatText(text, file))

        print(f"  Text in output file ../docs/{file} replaced")

    print("  Done")
  

def printHelp():
    print("Enter a filepath such as blog-posts/music.html to generate it in the parent directory.")
    print("--help to print this message or --all or -A to generate all detectable files.")


def main():
    if len(sys.argv) == 1:
        printHelp()
    else:
        if sys.argv[1] == "--help":
            printHelp()
        elif sys.argv[1] == "--all" or sys.argv[1] == "-A":
            genFiles()
        else:
            genFile(sys.argv[1])


if __name__ == "__main__":
    main() #change
