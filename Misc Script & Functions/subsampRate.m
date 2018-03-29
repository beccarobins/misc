%Figure out your subsample conversion factor

higherSampRate = input('What is your higher sampling rate\n');
lowerSampRate = input('\nWhat is your lower sampling rate?\n');

conversionFactor = higherSampRate/lowerSampRate;
conversionFactor = num2str(conversionFactor);

display(strcat('Use a conversion factor of',{' '},conversionFactor, {' '}, 'to subsample your higher sampled data'));
clear