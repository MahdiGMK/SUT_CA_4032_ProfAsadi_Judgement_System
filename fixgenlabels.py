import sys

# print()
# print()
# print()
for fname in sys.argv[1:]:
    # print(f'fixing {fname}')

    out_tokens = []
    with open(fname) as file:
        lines = []
        for line in file.readlines():
            if not line.strip().startswith('//'):
                lines.append(line)
        token_stream = "".join(lines).split()

        NULL            = 0
        INGEN           = 1
        BEGIN           = 2
        DOUBLE_QUOTES   = 3

        state = NULL
        for token in token_stream:
            if state == NULL:
                if token == 'generate' : state = INGEN
            elif state == INGEN:
                if token == 'begin'         : state = BEGIN
                if token == 'begin:'        : state = DOUBLE_QUOTES
                if token == 'endgenerate'   : state = NULL
            elif state == BEGIN:
                if token == ':'             : state = DOUBLE_QUOTES
                if token == 'begin'         : state = BEGIN
                if token == 'endgenerate'   : state = NULL
            elif state == DOUBLE_QUOTES:
                state = INGEN
                out_tokens.append(f'gen_{token}')
                continue
            out_tokens.append(token)
    with open(fname, 'w') as file:
        file.write('\n'.join(out_tokens))

# print()
# print()
# print()
