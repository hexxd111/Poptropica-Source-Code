stop();
if(camera.scene.red5)
{
   errorTimer = setInterval(this,"showErrorMessage",errorInterval);
   Connect();
}
else
{
   play();
}
