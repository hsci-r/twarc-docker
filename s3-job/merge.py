import sys
import re
import heapq
import gzip

def decorated_file(f, key):
    """ Yields an easily sortable tuple. 
    """
    for line in f:
        yield (key(line), line,f.name)

def standard_keyfunc(line):
    """ The standard key function in my application.
    """
    return line

def mergeSortedFiles(paths, idspath, keyfunc=standard_keyfunc):
    """ Does the same thing SortedFileMerger class does. 
    """
    files = list(map(open, paths)) #open defaults to mode='r'
    lines = {f.name:0 for f in files}
    dupLines = {f.name:0 for f in files}
    previous_file = None
    previous_comparable = None
    tlines = 0
    with gzip.open(idspath,"wt") as idsf:
        idsre = re.compile('"id_str": "(.*?)"')
        for line in heapq.merge(*[decorated_file(f, keyfunc) for f in files]):
            lines[line[2]] += 1
            comparable = line[0]
            if previous_comparable != comparable:
                print(line[1], end = '')
                tlines += 1
                m = idsre.search(line[1])
                if m is not None:
                    print(m[1],file=idsf)
                previous_file = line[2]
                previous_comparable = comparable
            else:
                if previous_file != None:
                    dupLines[previous_file] += 1
                    previous_file = None
                dupLines[line[2]] += 1
    return (lines,dupLines,tlines)

def main():
    (lines,dupLines,tlines) = mergeSortedFiles(sys.argv[1:-2],sys.argv[-2])
    with open(sys.argv[-1],"a") as logf:
        for k in lines:
            uniqLines = lines[k]-dupLines[k]
            if lines[k]==0:
                out = "{}: 0/0 (0%)".format(k)
            else:
                out = "{}: {:,}/{:,} ({:.2%})".format(k,uniqLines,lines[k],uniqLines/lines[k])
            print(out,file=logf)
            print(out,file=sys.stderr)
        out = "Wrote {:,} tweets.".format(tlines)
        print(out,file=logf)
        print(out,file=sys.stderr)

if __name__ == "__main__":
    main()

