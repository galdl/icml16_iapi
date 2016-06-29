function sendSSHCommand(command)
[r,o]=unix(['ssh ','''gald@hermes.technion.ac.il''',' ','''',command,'''']);
