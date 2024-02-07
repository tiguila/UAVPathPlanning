## Drone mesh set up in Unreal project



In your Unreal project, create two folders under Content:
- 1. Drone
- 2. MilitaryDrone



1. Under Drone directory: paste T_DroneHUD.png


2. Under MilitaryDrone directory, paste the whole whole **MilitaryDrone** from the folder above.


3. Replace the current actor with this drone model
- Under Content Drawer go to: Content/ThirdPerson/Blueprints **and** double click **BP_ThirdPersonCharacter**

- Under **Details**
Go to **Mesh** and change the **Skeletal Mesh Asset** to drone_model
