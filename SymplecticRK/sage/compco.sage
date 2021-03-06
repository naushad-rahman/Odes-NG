#------------------------------------------------------------------------
# compute the coefficients for the continuous output based starting
# approximation for starting approximations (Hairer and co. page 326).
#-----------------------------------------------------------------------
R.<x> = QQbar[] #the polynomial ring.

def ccoeffs(s,Rcoeffs,Rpivot):
    x=R.gen()
    RQ=R.base_ring()
    p=x^s*(x-1)^s
    l=p.derivative(x,s) #the polynomial.
    theRoots=[(l.roots()[i][0]).real() for i in range(0,s)]
    # the Vandermonde matrix:
    V=Matrix(RQ,s,s)
    for j in range(0,s):
        for k in range(0,s):
            V[j,k]=theRoots[j]^k
    # the RHS:
    W=Matrix(RQ,s,s)
    for k in range(0,s):
        for i in range(0,s):
            W[k,i]=((1+theRoots[i])^(k+1))/(k+1)
    Vt=V.transpose()
    Wt=W.transpose()
    # computing in algebraic numbers is too slow.
    # first, convert the V and W ti Rpivot, which is supposed to be a
    # set of very precise floats:
    V1=Vt.change_ring(Rpivot)
    W1=Wt.change_ring(Rpivot)
    
    # the continuous extrapolation coefficients:
    result=(V1\W1).transpose()
    return result.change_ring(Rcoeffs)
######################################################################
# "main" program starts here.
######################################################################

rngs=[(RDF,"double"),(RealField(112),"long double")]
Rpivot=RealField(1024)      
cc="copy(lc.begin(),lc.end(),c);\n"

fout=open("generated_coeffs_co.hpp","w")
for rng in rngs:
    Rout=rng[0]
    nm=rng[1]
    for i in range(2,17):
        a="template<> void extrapcoeffs<"+str(i)+","+nm+">("+nm+"* c)\n{\n"
        print "\n",nm,i
        fout.write(a)
        ll=ccoeffs(i,Rout,Rpivot).list()
        lc="initializer_list<double> lc={"
        for l in ll:
            lc+=str(l)+","
        lc=lc[:-1]+"};\n"
        fout.write(lc)
        fout.write(cc+"\n}\n")
fout.close()
print "end."
