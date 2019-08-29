#!/usr/bin/env python3
from mpl_toolkits.mplot3d import Axes3D  # Required for 3D plotting
import matplotlib.pyplot as plt
from skfuzzy import control as ctrl
import skfuzzy as fuzz
import numpy as np
'''
This script is a modified version of the 'plot_tipping_problem_newapi.py':
https://github.com/scikit-fuzzy/scikit-fuzzy/tree/master/docs/examples

Additionally it will also output a 3D plot and 2D plot.
Feel free to modify.

Make sure you run it in python3.x (not python2.7).

author: fuzzy.unesp@gmail.com
'''

print('Importing packages ...')
# numerical python

# fuzzy logic library

# library for plotting

# # Let's start:
print('Setting up 3 objects: porte, daf, estagio ...')
# New Antecedent/Consequent objects hold universe variables and membership
# functions
porte = ctrl.Antecedent(np.arange(0, 61, 1), 'Porte')
daf = ctrl.Antecedent(np.arange(0, 121, 1), 'D.A.F.')
estagio = ctrl.Consequent(np.arange(0, 11, 1), 'Estágio Sucessional')

# # Symmetric membership functions can be added with .automf(3, 5, or 7)
# porte.automf(3)
# daf.automf(3)

# Create membership functions
print('   ... create their membership functions')
porte['pequeno'] = fuzz.trapmf(porte.universe, [0, 0, 5, 20])
porte['médio'] = fuzz.trapmf(porte.universe, [5, 20, 30, 40])
porte['grande'] = fuzz.trapmf(porte.universe, [30, 40, 60, 60])

daf['fino'] = fuzz.trapmf(daf.universe, [0, 0, 10, 30])
daf['médio'] = fuzz.trapmf(daf.universe, [10, 30, 45, 60])
daf['grosso'] = fuzz.trapmf(daf.universe, [45, 60, 120, 120])

estagio['pioneiro'] = fuzz.trimf(estagio.universe, [0, 0, 3])
estagio['inicial'] = fuzz.trimf(estagio.universe, [0, 3, 8])
estagio['médio'] = fuzz.trimf(estagio.universe, [3, 8, 10])
estagio['avançado'] = fuzz.trimf(estagio.universe, [8, 10, 10])

# Look at the membership functions with .view()
print('   ... and take a look at the membership functions.')
porte.view()
daf.view()
estagio['médio'].view()


# # Add fuzzy rules
# note: 'label' is optional and not further used in the script
# '&' = AND
# '|' = OR
print('Define fuzzy rules')
regra1 = ctrl.Rule(porte['pequeno'] & daf['fino'],
                   estagio['pioneiro'],
                   label='regra pioneiro')

regra2 = ctrl.Rule(
    antecedent=(porte['pequeno'] & daf['médio']) |
               (porte['médio'] & daf['fino']),
    consequent=(estagio['inicial']),
    label='regra inicial')

regra3 = ctrl.Rule(
    antecedent=((porte['pequeno'] & daf['grosso']) |
                (porte['médio'] & daf['médio']) |
                (porte['grande'] & daf['fino'])),
    consequent=estagio['médio'],
    label='regra médio')

regra4 = ctrl.Rule(
    antecedent=(porte['médio'] & daf['grosso']) |
               (porte['grande'] & daf['médio']) |
               (porte['grande'] & daf['grosso']),
    consequent=estagio['avançado'],
    label='regra avançado')

# for weights add: consequent=(suc['...']%0.5)


# Control System Creation and Simulation
print('   ... and add them to the fuzzy control system.')
FIS_ctrl = ctrl.ControlSystem([regra1, regra2, regra3, regra4])
FIS = ctrl.ControlSystemSimulation(FIS_ctrl)


#####
yn = input('\nContinue with an example? (type \'no\' to exit) ')
if len(yn) and yn.lower()[0] == 'n':
    quit()

# Now we can pass inputs to the ControlSystem using Antecedent labels
input_porte, input_daf = 15.5, 32.2
print('Let\'s have an example:')

FIS.input['Porte'] = input_porte  # input value of porte
FIS.input['D.A.F.'] = input_daf  # input value of daf
# # Note: if you like passing both inputs all at once, use:
# FIS.inputs({'Porte': 5, 'D.A.F.': 7})
print('   ... INPUT  Porte   : %.9g m' % input_porte)
print('   ... INPUT  D.A.F.  : %.9g cm' % input_daf)

# Crunch the numbers
FIS.compute()

# show the output
print('   ... OUTPUT Estágio : %.4g' % FIS.output[estagio.label])

# make a graph
print('   Let\'s visualize the fuzzification.')
porte.view(sim=FIS)
daf.view(sim=FIS)
print('   ... and the defuzzification.')
estagio.view(sim=FIS)


# more plots?
yn = input('\nContinue to make more plots? (type \'no\' to exit) ')
if len(yn) and yn.lower()[0] == 'n':
    quit()

# ### Let's create a 3D plot
print('We can also make a 3D plot.')

# chose values that we want to plot
x_values = porte.universe[::4]  # take every 4th value
y_values = daf.universe[::8]  # take every 8th value
z_values = estagio.universe

# set up mesh (x,y)
x, y = np.meshgrid(x_values, y_values)
# set up output array z:
#   z has same shape as x but different data type (float - not integer)
z = np.zeros_like(x).astype(float)

# let's calculate the output for each value in porte and daf (this is slow!)
print('   ... but we will have to calculate each value individually.', end='')
print(' (this may take some time)')

for i in range(len(y_values)):
    for j in range(len(x_values)):
        # watch progress
        print('   ... %i/%i\r' % (1+i*len(x_values)+j, len(y_values)*len(x_values)), end='')

        # set up input
        FIS.inputs({'Porte': x_values[j],
                    'D.A.F.': y_values[i]})

        # compute values
        FIS.compute()

        # save output to array
        z[i, j] = FIS.output[estagio.label]

# empty output line
print('')

# set up a figure and axes (frame)
fig = plt.figure(figsize=(8, 8))
ax = fig.add_subplot(111, projection='3d')

# do the plot
surf = ax.plot_surface(x, y, z, rstride=1, cstride=1, cmap='viridis',
                       linewidth=0.4, antialiased=True)

# set labels
ax.set_xlabel('Porte [m]')
ax.set_ylabel('D.A.F. [cm]')
ax.set_zlabel(estagio.label)

# set range of z (this is optional)
ax.set_zlim(bottom=np.min(z_values), top=np.max(z_values))


# # some extra plotting (partly disabled because maybe confusing)
cset = ax.contourf(x, y, z, zdir='z', offset=-2.5, cmap='viridis', alpha=0.5)
# cset = ax.contourf(x, y, z, zdir='x', offset=80, cmap='viridis', alpha=0.5)
# cset = ax.contourf(x, y, z, zdir='y', offset=150, cmap='viridis', alpha=0.5)

# set up the angle from which we watch the 3D plot
ax.view_init(30, 200)


# make a second figure
print('   ... and we will also make a 2D plot.')
fig2 = plt.figure(figsize=(8, 8))
ax = fig2.add_subplot(111)
contourplot = ax.contourf(x, y, z, 300,
                          levels=np.linspace(np.min(z_values),
                                             np.max(z_values),
                                             21),
                          cmap='nipy_spectral')

# addtionally plot three lines that seperate the 4 Estágio Sucessional
ax.contour(x, y, z, colors='k', levels=[1.5, 5.5, 9])

# set labels
ax.set_xlabel('Porte [m]')
ax.set_ylabel('D.A.F. [cm]')

# add a colorbar that
cbar = fig2.colorbar(contourplot, ticks=z_values, extend='both')
cbar.set_label(estagio.label)

# show us all plots
print('Now show us all figures.')
plt.show()
