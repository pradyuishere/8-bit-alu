import sys

mov_str  = '01'
mvi_str1 = '00'
mvi_str2 = '110'
lxi_str1 = '00'
lxi_str2 = '0001'
lda_str  = '00111010'
sta_str  = '00110010'
lhld_str = '00101010'
shld_str = '00100010'
ldax_str1= '00'
ldax_str2= '1010'
stax_str1= '00'
stax_str2= '0010'
xchg_str = '11101011'
add_str  = '10000'
adi_str  = '11000110'
adc_str  = '10001'
aci_str  = '11001110'
sub_str  = '10010'
sui_str  = '11010110'
sbb_str  = '10011'
sbi_str  = '11011110'
inr_str1 = '00'
inr_str2 = '100'
dcr_str1 = '00'
dcr_str2 = '101'
inx_str1 = '00'
inx_str2 = '0011'
dcx_str1 = '00'
dcx_str2 = '1011'
dad_str1 = '00'
dad_str2 = '1001'
daa_str  = '00100111'
ana_str  = '10100'
ani_str  = '11100110'
ora_str  = '10110'
ori_str  = '11110110'
xra_str  = '10101'
xri_str  = '11101110'
cmp_str  = '10111'
cpi_str  = '11111110'
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
call_str = '11001101'
cccc_str1= '11'
cccc_str2= '100'
ret_str  = '11001001'
rccc_str1= '11'
rccc_str2= '000'
rst_str1 = '11'
rst_str2 = '111'
pchl_str = '11101001'
push_str1= '11'
push_str2= '0101'
pop_str1 = '11'
pop_str2 = '0001'
xthl_str = '11100011'
sphl_str = '11111001'
in_str   = '11011011'
out_str  = '11010011'
ei_str   = '11111011'
di_str   = '11110011'
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
        if words[0]=='LXI':
            str_out = lxi_str1+"{0:02b}".format(int(words[1]))+lxi_str2+"{0:016b}".format(int(words[2]))
        if words[0]=='LDA':
            str_out = lda_str+"{0:016b}".format(int(words[1]))
        if words[0]=='STA':
            str_out = sta_str+"{0:016b}".format(int(words[1]))
        if words[0]=='LHLD':
            str_out = lhld_str+"{0:016b}".format(int(words[1]))
        if words[0]=='SHLD':
            str_out = shld_str+"{0:016b}".format(int(words[1]))
        if words[0]=='LDAX':
            str_out = ldax_str1+"{0:02b}".format(int(words[1]))+ldax_str2
        if words[0]=='STAX':
            str_out = stax_str1+"{0:02b}".format(int(words[1]))+stax_str2
        if words[0]=='XCHG':
            str_out = xchg_str1
        if words[0]=='ADD':
            str_out = add_str+"{0:03b}".format(int(words[1]))
        if words[0]=='ADI':
            str_out = adi_str+"{0:08b}".format(int(words[1]))
        if words[0]=='ADC':
            str_out = adc_str+"{0:03b}".format(int(words[1]))
        if words[0]=='ACI':
            str_out = aci_str+"{0:08b}".format(int(words[1]))
        if words[0]=='SUB':
            str_out = sub_str+"{0:03b}".format(int(words[1]))
        if words[0]=='SUI':
            str_out = sui_str+"{0:08b}".format(int(words[1]))
        if words[0]=='SBB':
            str_out = sbb_str+"{0:03b}".format(int(words[1]))
        if words[0]=='SBI':
            str_out = sbi_str+"{0:08b}".format(int(words[1]))
        if words[0]=='INR':
            str_out = inr_str1+"{0:03b}".format(int(words[1]))+inr_str2
        if words[0]=='DCR':
            str_out = dcr_str1+"{0:03b}".format(int(words[1]))+dcr_str2
        if words[0]=='INX':
            str_out = inx_str1+"{0:02b}".format(int(words[1]))+inx_str2
        if words[0]=='DCX':
            str_out = dcx_str1+"{0:02b}".format(int(words[1]))+dcx_str2
        if words[0]=='DAD':
            str_out = dad_str1+"{0:02b}".format(int(words[1]))+dad_str2
        if words[0]=='DAA':
            str_out = daa_str
        if words[0]=='ANA':
            str_out = ana_str+"{0:03b}".format(int(words[1]))
        if words[0]=='ANI':
            str_out = daa_str+"{0:08b}".format(int(words[1]))
        if words[0]=='ORA':
            str_out = ora_str+"{0:03b}".format(int(words[1]))
        if words[0]=='ORI':
            str_out = ori_str
        if words[0]=='XRA':
            str_out = xra_str+"{0:03b}".format(int(words[1]))
        if words[0]=='XRI':
            str_out = xri_str+"{0:08b}".format(int(words[1]))
        if words[0]=='CMP':
            str_out = cmp_str+"{0:03b}".format(int(words[1]))
        if words[0]=='cpi':
            str_out = cpi_str+"{0:08b}".format(int(words[1]))
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
        if words[0]=='STC':
            str_out = stc_str
        if words[0]=='JMP':
            str_out = jmp_str+"{0:016b}".format(int(words[1]))
        if words[0]=='Jccc':
            str_out = jccc_str1+"{0:03b}".format(int(words[1]))+jccc_str2+"{0:016b}".format(int(words[2]))
        if words[0]=='CALL':
            str_out = call_str+"{0:016b}".format(int(words[1]))
        if words[0]=='Cccc':
            str_out = cccc_str1+"{0:03b}".format(int(words[1]))+cccc_str2+"{0:016b}".format(int(words[2]))
        if words[0]=='RET':
            str_out = ret_str
        if words[0]=='Rccc':
            str_out = rccc_str1+"{0:03b}".format(int(words[1]))+rccc_str2
        if words[0]=='RST':
            str_out = rst_str1+"{0:03b}".format(int(words[1]))+rst_str2
        if words[0]=='PCHL':
            str_out = pchl_str
        if words[0]=='PUSH':
            str_out = push_str1+"{0:02b}".format(int(words[1]))+push_str2
        if words[0]=='POP':
            str_out = pop_str1+"{0:02b}".format(int(words[1]))+pop_str2
        if words[0]=='XTHL':
            str_out = xthl_str
        if words[0]=='SPHL':
            str_out = sphl_str
        if words[0]=='IN':
            str_out = in_str+"{0:08b}".format(int(words[1]))
        if words[0]=='OUT':
            str_out = out_str+"{0:08b}".format(int(words[1]))
        if words[0]=='EI':
            str_out = ei_str
        if words[0]=='DI':
            str_out = di_str
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
