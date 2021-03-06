      subroutine soldir (en,fl,agi,api,ainf,nq,kap,max0,ifail)
c                  resolution of the dirac equation
c                   p' - kap*p/r = - ( en/cl-v )*g - eg/r
c                   g' + kap*g/r = ( 2*cl+en/cl-v )*p + ep/r
c at the origin v approximately is -z/(r*cl) due to the point nucleus
c en one-electron energy in atomic units and negative
c fl power of the first term in development at the origin
c agi (api) initial values of the first development coefficient
c at the origin of the large(small)component
c ainf initial value for the large component at the point dr(max0)
c nq principal quantum number     kap quantum number kappa
c max0 the last point of tabulation of the wave function
c        this programm uses intdir
 
      implicit double precision (a-h,o-z)
      common/comdir/cl,dz,gg(251),ag(10),gp(251),ap(10),dv(251),av(10),
     2eg(251),ceg(10),ep(251),cep(10)
c gg,gp -output, dv,eg,ep - input
      dimension hg(251),agh(10),
     1hp(251),aph(10),bg(251),bgh(10),bp(251),bph(10)
c
c cl speed of light (approximately 137.037 in atomic units)
c dz nuclear charge
c gg (gp) large (small) component
c hg,hp,bg et bp working space
c dv direct potential (v)     eg and ep exchange potentials
c ag,ap,agh,aph,bgh,bph,av,ceg and cep are respectively the
c development coefficients for gg,gp,hg,hp,bg,bp,dv,eg et ep
c
      common/tabtes/hx,dr(251),test1,test2,ndor,np,nes,method,idim
c
c hx exponential step
c dr radial mesh
c test1 precision for the matching the small component if method=1
c test2 precision for the normalisation if method=2
c ndor number of terms for the developments at the origin
c np maximum number of the tabulation points
c nes maximum number of attempts to ajust the small component
c method at the initial time distinguish the homoginious (method=0)
c  from inhomoginious system. at the end is the index of method used.
c idim dimension of the block dr

      common/subdir/ell,fk,ccl,imm,nd,node,mat

c ell fk*(fk+1)/ccl     fk=kap     ccl=cl+cl
c imm a flag for the determination of matching point
c nd number of nodes found     node number of nodes to be found
c mat index of the matching point

      common/messag/dlabpr,numerr
      character*8 dprlab,dlabpr, drplab
c at the time of return numerr should be zero if integration is correct,
c otherwise numerr contains the number of instruction, which
c indicate the sourse and reason for abnornal return.
*     character*512 slog
      save

      data dprlab/'  soldir'/,drplab/'  intdir'/
      dlabpr=dprlab
      enav=1.0d 00
      ainf= abs(ainf)
      ccl=cl+cl
      iex=method
      if (method.le.0) method=1
c notice that iex=0,1 and method=1,2 only below.
c this was used to simplify block structure of program. ala 11/22/94
      fk=kap
      if (av(1).lt.0.0d 00.and.kap.gt.0) api=-agi*(fk+fl)/av(1)
      if (av(1).lt.0.0d 00.and.kap.lt.0) api=-agi*av(1)/(fk-fl)
      ell=fk*(fk+1.0d 00)/ccl
      node=nq- abs(kap)
      if (kap.lt.0) node=node+1
      emin=0.0
      do 91 i=1,np
         a=(ell/(dr(i)*dr(i))+dv(i))*cl
         if (a.lt.emin) emin=a
 91   continue
      if (emin .ge. 0.0) then
         numerr=75011
c       *potential is apparently positive
         return
      endif
      if (en.lt.emin) en=emin*0.9d 00
      edep=en

 101  numerr=0
      test=test1
      if (method.gt.1) test=test2
      einf=1.0d 00
      esup=emin
      en=edep
      ies=0
      nd=0
 105  jes=0
 106  modmat=0
      imm=0
      if ( abs((enav-en)/en).lt.1.0d-01) imm=1
      enav=en
 
c     integration of the inhomogenious system
 107  do 111 i=1,idim
         gg(i)=eg(i)
 111     gp(i)=ep(i)
      do 115 i=2,ndor
         ag(i)=ceg(i-1)
 115     ap(i)=cep(i-1)
      call intdir (gg,gp,ag,ap,ggmat,gpmat,en,fl,agi,api,ainf,max0)
      if (numerr.ne.0) then
         dlabpr=drplab
         return
      endif
      if (iex.ne.0) go to 141
 
c     match large component for the homogenios system(method=0)
      a=ggmat/gg(mat)
      do 135 i=mat,max0
         gg(i)=a*gg(i)
 135     gp(i)=a*gp(i)
      j=mat
      go to 215
 
c     integration of the homogenios system
 141  do 151 i=1,idim
            hg(i)=0.0d 00
 151     hp(i)=0.0d 00
      do 155 i=1,ndor
         agh(i)=0.0d 00
 155     aph(i)=0.0d 00
      imm=1
      if (method.eq.1) imm=-1
      call intdir (hg,hp,agh,aph,hgmat,hpmat,en,fl,agi,api,ainf,max0)
 
c     match the large component for inhomogenious system(method=1)
      a=gg(mat)-ggmat
      if (method.lt.2) then
         b=-a/hg(mat)
      else
         b=gp(mat)-gpmat
         ah=hpmat*hg(mat)-hgmat*hp(mat)
         if (ah.eq.0.0d 00) go to 263
         c=(b*hg(mat)-a*hp(mat))/ah
         b=(b*hgmat-a*hpmat)/ah
         do 165 i=1,ndor
            ag(i)=ag(i)+c*agh(i)
 165        ap(i)=ap(i)+c*aph(i)
         j=mat-1
         do 168 i=1,j
            gg(i)=gg(i)+c*hg(i)
 168        gp(i)=gp(i)+c*hp(i)
      endif
      do 173 i=mat,max0
         gg(i)=gg(i)+b*hg(i)
 173     gp(i)=gp(i)+b*hp(i)

      if (method.ge.2) then
c        integration of the system derived from disagreement in energy
         do 175 i=2,ndor
            bgh(i)=ag(i-1)/cl
 175        bph(i)=ap(i-1)/cl
         do 177 i=1,max0
            bg(i)=gg(i)*dr(i)/cl
 177        bp(i)=gp(i)*dr(i)/cl
         call intdir (bg,bp,bgh,bph,bgmat,bpmat,en,fl,agi,api,ainf,max0)
 
c        match both components for inhomogenious system (method=2)
         f=bg(mat)-bgmat
         g=bp(mat)-bpmat
         a=(g*hg(mat)-f*hp(mat))/ah
         g=(g*hgmat-f*hpmat)/ah
         do 181 i=1,j
            bg(i)=bg(i)+a*hg(i)
 181        bp(i)=bp(i)+a*hp(i)
         do 182 i=1,ndor
            bgh(i)=bgh(i)+a*agh(i)
 182        bph(i)=bph(i)+a*aph(i)
         do 183 i=mat,max0
            bg(i)=bg(i)+g*hg(i)
 183        bp(i)=bp(i)+g*hp(i)
c        calculate the norm 
         call norm(b,hp,dr,gg,gp,ag,ap,method,hx,ndor,
     1     gpmat,fl,max0,mat)
 
c        correction to the energy (method=2)
         do 186 i=1,max0
 186     hg(i)=(gg(i)*bg(i)+gp(i)*bp(i))*dr(i)
         ah=0.0d 00
         c=0.0d 00
         do 187 i=2,max0,2
 187     ah=ah+hg(i)+hg(i)+hg(i+1)
         ah=hx*(ah+ah+hg(1)-hg(max0))/3.0d 00+hg(1)/(fl+fl+1.0d 00)
         f=(1.0d 00-b)/(ah+ah)
         c=1.0d 00-b
         do 191 i=1,max0
            gg(i)=gg(i)+f*bg(i)
 191        gp(i)=gp(i)+f*bp(i)
         do 195 i=1,ndor
            ag(i)=ag(i)+f*bgh(i)
 195        ap(i)=ap(i)+f*bph(i)
      endif
 
c     search for the maximum of the modulus of large component
      a=0.0d 00
      bgh(1)=b
      bph(1)=ah
      do 211 i=1,max0
         g=gg(i)*gg(i)
         if (g.le.a) go to 211
         a=g
         j=i
 211  continue
      if (j.gt.mat .and. modmat.eq.0) then
         modmat=1
         mat=j
         if (mod(mat,2).eq.0) mat=mat+1
         imm=1
         if (mat.lt.(max0-10)) go to 107

         mat=max0-12
         j=mat
         if (mod(mat,2).eq.0) mat=mat+1
c        write(slog,'(a,i4,a,i4)') ' warning  mat=',mat,' max0=',max0
c        call wlog(slog)
      endif
c this case can happen due to bad starting point in scf procedure.
c ignore this warning unless you are getting it at final norb calls
c of soldir
c  redirected by ala 11/21/94.
c     numerr=220021
c * impossible matching point
c     go to 899
 
c compute number of nodes
 215  nd=1
      j= max(j,mat)
      do 231 i=2,j
         if (gg(i-1).eq.0.0d 00) go to 231
         if ((gg(i)/gg(i-1)).le.0.0d 00) nd=nd+1
 231  continue

      if (nd-node) 251,305,261
 251  esup=en
      if (einf.lt.0.0d 00) go to 271
      en=en*8.0d-01
      if ( abs(en).gt.test1) go to 285
      numerr=238031
c    *zero energy
      go to 899

 261  einf=en
      if (esup.gt.emin) go to 271
 263  en=en*1.2d 00
      if (en.gt.emin) go to 285
      numerr=245041
c    *energy is lower than the minimum of apparent potential
      go to 899

 271  if ( abs(einf-esup).gt.test1) go to 281
      numerr=249051
c    *the upper and lower limits of energy are identical
      go to 899

 281  en=(einf+esup)/2.0d 00

 285  jes=jes+1
      if (jes.le.nes) go to 106
 
c *number of attempts to find good number of nodes is over the limit
c this case can happen due to bad starting point in scf procedure.
c ignore this warning unless you  got it at final norb calls of soldir
c     call wlog('warning jes>nes')
      ifail=1
c    *redirected by ala 11/21/94.
c     numerr=255061
c     go to 899

c     calculation of the norm
 305  call norm(b,hp,dr,gg,gp,ag,ap,method,hx,ndor,
     1     gpmat,fl,max0,mat)
      if (method.eq.1) then
c        correction to the energy (method=1)
         c=gpmat-gp(mat)
         f=gg(mat)*c*cl/b
         if (gpmat.ne.0.0d 00) c=c/gpmat
      endif

      en=en+f
      g= abs(f/(en-f))
 371  if ((en.ge.0 .or. g.gt.2.0d-01) .or.
     1 (abs(c).gt.test .and. (en.lt.esup.or.en.gt.einf))) then
c        try smaller step in enrgy under above conditions
         f=f/2.0d 00
         g=g/2.0d 00
         en=en-f
         if (g.gt.test1) go to 371
         numerr=29071
c       *zero energy
         go to 899
      endif

      if ( abs(c).gt.test)  then
         ies=ies+1
         if (ies.le.nes) go to 105
         ifail=1
c        call wlog('warning: iteration stopped because ies=nes')
c     everything is fine unless you got this message on the latest stage
c     of selfconsistent process. just stopped trying to match lower
c     component, because number of trials exceeded limit.
c     lines below were commented out.  ala 11/18/94
      endif

c     numerr=298081
c    *number of attempts to match the lower component is over the limit
c     go to 899
 
c     divide by a square root of the norm, and test the sign of w.f.
      b= sqrt(b)
      c=b
      if ((ag(1)*agi).lt.0.0d 00.or.(ap(1)*api).lt.0.0d 00) c=-c
      do 711 i=1,ndor
         ag(i)=ag(i)/c
 711     ap(i)=ap(i)/c
      if ((gg(1)*agi).lt.0.0d 00.or.(gp(1)*api).lt.0.0d 00) b=-b
      do 721 i=1,max0
         gg(i)=gg(i)/b
 721     gp(i)=gp(i)/b
      if (max0.ge.np) return
      j=max0+1
      do 741 i=j,np
         gg(i)=0.0d 00
 741     gp(i)=0.0d 00
c     if everything o'k , exit is here.
      return

c     abnormal exit is here, if method.ne.1
 899  if (iex.eq.0 .or. method.eq.2) go to 999
      method=method+1
      go to 101

 999  return
      end

      subroutine norm(b,hp,dr,gg,gp,ag,ap,method,hx,ndor,
     1 gpmat,fl,max0,mat)
c    calculate norm b. this part of original code was used twice,
c    causing difficult block structure. so it was rearranged into
c    separate subroutine. ala 
      implicit double precision (a-h, o-z)
      dimension hp(251),dr(251),gg(251),gp(251),ag(10),ap(10)

      b=0.0d 00
      do 311 i=1,max0
 311  hp(i)=dr(i)*(gg(i)*gg(i)+gp(i)*gp(i))
      if (method.ne.1) go to 315
      hp(mat)=hp(mat)+dr(mat)*(gpmat**2-gp(mat)**2)/2.0d 00
 315  do 321 i=2,max0,2
 321  b=b+hp(i)+hp(i)+hp(i+1)
      b=hx*(b+b+hp(1)-hp(max0))/3.0d 00
      do 325 i=1,ndor
         g=fl+fl+i
         g=(dr(1)**g)/g
         do 325 j=1,i
 325     b=b+ag(j)*g*ag(i+1-j)+ap(j)*g*ap(i+1-j)
      return
      end
