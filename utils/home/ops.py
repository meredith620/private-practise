#! /bin/env python3

import sys

def demo():
    print("this is demo")

def get_main_entry():
    main_map = {
        "demo": ("some demo des", demo),
        "demo2": {
            "level2": {
                "level3": ("some demo des", demo)
            }
        }
    }
    return main_map

def do_choice(item):
    print("your item", item)

def color_str(s, colorid):
    return "\033[01;%dm%s\033[00m" % (colorid, s)
    
def show_entry(entry):
    print("\n===<%s>===:" % color_str("entry", 33))
    for (key, item) in entry.items():        
        print("[%s]: %s" % (color_str(key, 36), item))
    print("[quit] to return")
    print("===============")
        
def entry_repl(entry):
    while True:
        show_entry(entry)
        text = input("your choice:")
        text = text.lower()
        if text in entry:
            item = entry[text]
            if type(item) == type({}):
                entry_repl(item)
            elif type(item) == type(()) or type(item) == type([]):
                do_choice(item)
        elif text == "quit":
            break
        else:
            print("your input could not be understood!")
                

def main():
    main_entry = get_main_entry()
    entry_repl(main_entry)

if __name__ == "__main__":
    main()

