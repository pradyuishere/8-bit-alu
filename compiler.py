# http://www.classiccmp.org/dunfield/r/8080.txt
import sys

mov_str  = '01'
mvi_str1 = '00'
mvi_str2 = '110'
add_str  = '10000'
adc_str  = '10001'
sub_str  = '10010'
sbb_str  = '10011'
inr_str1 = '00'
inr_str2 = '100'
dcr_str1 = '00'
dcr_str2 = '101'
ana_str  = '10100'
ora_str  = '10110'
xra_str  = '10101'
cmp_str  = '10111'
rlc_str  = '00000111'
rrc_str  = '00001111'
ral_str  = '00010111'
rar_str  = '00011111'
cma_str  = '00101111'
cmc_str  = '00111111'
stc_str  = '00110111'
jmp_str  = '11000011'
jccc_str1= '11'
jccc_str2= '010'
ret_str  = '11001001'
rccc_str1= '11'
rccc_str2= '000'
hlt_str  = '01110110'
nop_str  = '00000000'


try:
    file = open(sys.argv[1], 'r')
    file2= open('out.txt', 'w')
    for line in file:
        str_out = ''
        words = line[:-1].split(' ')
        if words[0]=='MOV':
            str_out = mov_str+"{0:03b}".format(int(words[1]))+"{0:03b}".format(int(words[2]))
        if words[0]=='MVI':
            str_out = mvi_str1+"{0:03b}".format(int(words[1]))+mvi_str2+"{0:08b}".format(int(words[2]))
        if words[0]=='ADD':
            str_out = add_str+"{0:03b}".format(int(words[1]))
        if words[0]=='ADI':
            str_out = adi_str+"{0:08b}".format(int(words[1]))
        if words[0]=='ADC':
            str_out = adc_str+"{0:03b}".format(int(words[1]))
        if words[0]=='SUB':
            str_out = sub_str+"{0:03b}".format(int(words[1]))
        if words[0]=='SBB':
            str_out = sbb_str+"{0:03b}".format(int(words[1]))
        if words[0]=='INR':
            str_out = inr_str1+"{0:03b}".format(int(words[1]))+inr_str2
        if words[0]=='DCR':
            str_out = dcr_str1+"{0:03b}".format(int(words[1]))+dcr_str2
        if words[0]=='ANA':
            str_out = ana_str+"{0:03b}".format(int(words[1]))
        if words[0]=='ORA':
            str_out = ora_str+"{0:03b}".format(int(words[1]))
        if words[0]=='XRA':
            str_out = xra_str+"{0:03b}".format(int(words[1]))
        if words[0]=='CMP':
            str_out = cmp_str+"{0:03b}".format(int(words[1]))
        if words[0]=='RLC':
            str_out = rlc_str
        if words[0]=='RRC':
            str_out = rrc_str
        if words[0]=='RAL':
            str_out = ral_str
        if words[0]=='RAR':
            str_out = rar_str
        if words[0]=='CMA':
            str_out = cma_str
        if words[0]=='CMC':
            str_out = cmc_str
        if words[0]=='JMP':
            str_out = jmp_str+"{0:08b}".format(int(words[1]))
        if words[0]=='Jccc':
            str_out = jccc_str1+"{0:03b}".format(int(words[1]))+jccc_str2+"{0:08b}".format(int(words[2]))
        if words[0]=='HLT':
            str_out = hlt_str
        if words[0]=='NOP':
            str_out = nop_str
        print(words[0])
        print(str_out)
        file2.write(str_out)
        file2.write("\n")
finally:
    file.close()
