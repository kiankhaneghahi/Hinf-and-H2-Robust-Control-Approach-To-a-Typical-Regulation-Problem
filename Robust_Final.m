clear all;
close all;
clc;

%% System State Space Representation :

A = [0      1     0    0      0
     -1     -0.2  0    0      0
     0      0     -1   0      0
     0      0     0    0      1
     -1     0     0    -5     -10.5];
 
B1 = [0
      0
      0
      0
      1];
  
B2 = [0
      1
      1
      0
      0];
  
C1 = [0     0      0       10        2
      0     0      0.81    0         0
      49500 9900   0       0         0];
  
C2 = [-1    0      0       0         0];

D11 = [0
       0
       0];
   
D12 = [0
       0.09
       500];
   
D21 = 1;

D22 = 0;

B = [B1,B2];
C = [C1;C2];
D = [D11 D12;D21 D22];

P_sys = ss(A,B,C,D);
P_sys.InputName = {'y_d','u'};
P_sys.OutputName = {'Z1','Z2','Z3','y'};

%% System State Space Representation (Improved) :

A = [0      1     0    0      0
     -1     -0.2  0    0      0
     0      0     -1   0      0
     0      0     0    0      1
     -1     0     0    -5     -10.5];
 
B1 = [0
      0
      0
      0
      1];
  
B2 = [0
      1
      1
      0
      0];
  
C1 = [0     0      0       10        2
      0     0      0.81    0         0
      0.099    0.0198   0       0         0];
  
C2 = [-1    0      0       0         0];

D11 = [0
       0
       0];
   
D12 = [0
       0.09
       0.001];
   
D21 = 1;

D22 = 0;

B = [B1,B2];
C = [C1;C2];
D = [D11 D12;D21 D22];

P_sys = ss(A,B,C,D);
P_sys.InputName = {'y_d','u'};
P_sys.OutputName = {'Z1','Z2','Z3','y'};




%% Hinf synthesis :

[K_Hinf sys_CL_Hinf gamma INFO_Hinf] = hinfsyn(P_sys,1,1)
K_Hinf_tf = tf(K_Hinf)

figure(1);
bode(sys_CL_Hinf);

figure(2);
step(sys_CL_Hinf);

[U,S,V]=svd(sys_CL_Hinf.A);

figure(3);
loops = loopsens(ss(A,B2,C2,D22),K_Hinf); 
bode(loops.Si,'r',loops.Ti,'b',loops.Li,'g');
legend('S','T','Loop gain');

%% H2 synthesis :

[K_H2 sys_CL_H2 gamma_H2 INFO_H2] = h2syn(P_sys,1,1)
K_H2_tf = tf(K_H2)

figure(4);
bode(sys_CL_H2);

figure(5);
step(sys_CL_H2);

figure(6);
loops = loopsens(ss(A,B2,C2,D22),K_H2); 
bode(loops.Si,'r',loops.Ti,'b',loops.Li,'g');
legend('S','T','Loop gain');