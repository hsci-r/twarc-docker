import sys
import heapq

def decorated_file(f, key):
    """ Yields an easily sortable tuple. 
    """
    for line in f:
        yield (key(line), line,f.name)

def standard_keyfunc(line):
    """ The standard key function in my application.
    """
    return line

def mergeSortedFiles(paths, keyfunc=standard_keyfunc):
    """ Does the same thing SortedFileMerger class does. 
    """
    files = list(map(open, paths)) #open defaults to mode='r'
    lines = {f.name:0 for f in files}
    dupLines = {f.name:0 for f in files}
    previous_file = None
    previous_comparable = None
    for line in heapq.merge(*[decorated_file(f, keyfunc) for f in files]):
        lines[line[2]] += 1
        comparable = line[0]
        if previous_comparable != comparable:
            print(line[1], end = '')
            previous_file = line[2]
            previous_comparable = comparable
        else:
            if previous_file != None:
                dupLines[previous_file] += 1
                previous_file = None
            dupLines[line[2]] += 1
    return (lines,dupLines)

def main():
    (lines,dupLines) = mergeSortedFiles(sys.argv[1:])
    for k in lines:
        print(k+": "+str(lines[k]-dupLines[k])+"/"+str(lines[k]),file=sys.stderr)

if __name__ == "__main__":
    main()

