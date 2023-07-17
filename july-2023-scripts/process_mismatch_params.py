
import os

switch_param = 'MC_SWITCH'

for dirpath, dirnames, filenames in os.walk('cells'):
    for filename in filenames:
        if filename[-6:] == '.spice':
            infile_name = os.path.join(dirpath, filename)
            outfile_name = os.path.join(dirpath, 'temp')

            print("Found spice file '{}'.".format(infile_name))

            infile = open(infile_name, 'r')
            outfile = open(outfile_name, 'w')

            mismatch_params = []
            state = 'before_mismatch'
            line_number = 0
            replaced_something = False

            for line in infile:
                line_number += 1
                if state == 'before_mismatch':
                    outfile.write(line)
                    if line == '*   mismatch {\n':
                        state = 'in_mismatch'
                elif state == 'in_mismatch':
                    outfile.write(line)
                    if line == '*   }\n':
                        state = 'after_mismatch'
                    else:
                        tokens = line.split()
                        if 'vary' in tokens:
                            if ('dist=gauss' in tokens) or ('gauss' in tokens):
                                mismatch_param = tokens[2]
                                std_dev = float(tokens[-1].split('=')[-1])
                                replacement = '{}*AGAUSS(0,{!s},1)'.format(switch_param, std_dev)
                                mismatch_params.append((mismatch_param, replacement))
                                print("  Line {}: Found mismatch parameter '{}' to be replaced by '{}'.".format(line_number, mismatch_param, replacement))
                elif state == 'after_mismatch':
                    newline = line
                    for (param, replacement) in mismatch_params:
                        if param in newline:
                            newline = newline.replace(param, replacement)
                            replaced_something = True
                            print("  Line {}: Found '{}' and replaced with '{}'.".format(line_number, param, replacement))
                    outfile.write(newline)

            infile.close()
            outfile.close()
            if replaced_something:
                print("Something was replaced in '{}', backed up original file and replaced with processed one.".format(infile_name))
                os.rename(infile_name, infile_name + '.orig')
                os.rename(outfile_name, infile_name)
            else:
                print("Nothing was replaced in '{}'.".format(infile_name))
                os.remove(outfile_name)

