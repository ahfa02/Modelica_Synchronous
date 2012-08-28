within Modelica_Synchronous;


package WorkInProgress "Models that are under developmend and test models"
  package Incubate "Stuff that might be adapted and used at some future time"

    package TrueTime
      "Communication block and external C interface of TrueTime simulators."
    extends Modelica_Synchronous.WorkInProgress.Icons.PackageNotReady;
      package ExternalC
        "Implementation of TrueTime kernel and network simulators in external C-code"
        class Kernel "External C interface of kernel simulator"
        extends ExternalObject;

        encapsulated function constructor
            "Initialize simulated real-time kernel"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

          input Integer policy "Scheduling policy";
          input Integer numberOfTasks "Number of tasks";
          output Kernel kernelHandle "Handle to kernel simulator object";

          external "C" kernelHandle = Kernel_Init(policy, numberOfTasks);

          annotation (Include="#include \"./Extras/C-Sources/TrueTime/kernel.c\"");
        end constructor;

        encapsulated function destructor "Terminate simulated real-time kernel"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

          input Kernel kernelHandle "Handle to kernel simulator object";

          external "C" Kernel_Terminate(kernelHandle);

        end destructor;

          encapsulated function runKernel "Run the kernel simulator instance"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input Real currTime "Current time";

            external "C" runKernel(kernelHandle, currTime);

          end runKernel;

          encapsulated function getNextHitKernel
            "Get next event time for kernel simulator"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input Real currTime "Current time";
            output Real nextT "Next event time";

            external "C" nextT = getNextHitKernel(kernelHandle, currTime);

          end getNextHitKernel;

          encapsulated function getSchedule "Get the real-time task schedule"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input Integer numberOfTasks "Number of tasks";
            input Real currTime "Current time";
            output Real schedule[numberOfTasks] "Task schedule";

            external "C" getSchedule(kernelHandle, schedule, numberOfTasks);

          end getSchedule;

          encapsulated function createTask
            "Create a real-time kernel task (called during initialization)"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input Integer taskID "Task ID";
            input String taskName "Task name";
            input Real period "Task period";
            input Integer priority "Task priority";
            input Real deadline "Task (relative) deadline";
            input Real offset "Task offset";
            output Integer errNo "To indicate success";

            external "C" errNo = createTask(kernelHandle, taskID, taskName, period, priority, deadline, offset);

          end createTask;

          encapsulated function createJob
            "Create task instance for controller calculation"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input String taskName "Task name";
            input Real executionTimeCalculate "Time to calculate outputs";
            input Real executionTimeUpdate "Time to update states";
            input Real currTime "Current time";
            output Integer errNo "To indicate success";

            external "C" errNo = createJob(kernelHandle, taskName, executionTimeCalculate, executionTimeUpdate, currTime);

          end createJob;

          encapsulated function createJobNw
            "Create task instance for controller calculation and network transmission"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input String taskName "Task name";
            input Real executionTimeCalculate "Time to calculate outputs";
            input Real executionTimeUpdate "Time to update states";
            input Network networkHandle "Handle to network simulator object";
            input Integer frameDataSize "Size of frame data";
            input Integer frameID "Frame ID";
            input Integer framePriority "Frame priority";
            input Real currTime "Current time";
            output Integer errNo "To indicate success";

            external "C" errNo = createJobNw(kernelHandle, taskName, executionTimeCalculate, executionTimeUpdate,
                                            networkHandle, frameDataSize, frameID, framePriority, currTime);

          end createJobNw;

        encapsulated function setControl "Set computed control signal for task"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input String taskName "Task name";
            input Real u "Control signal";
            input Real currTime "Current time";
            output Integer errNo "To indicate success";

            external "C" errNo = setControl(kernelHandle, taskName, u, currTime);

        end setControl;

        encapsulated function analogOut "Output calculated control signal"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel;

            input Kernel kernelHandle "Handle to kernel simulator object";
            input String taskName "Task name";
            input Real currTime "Current time";
            input Real u "Dummy input for correct incidence";
            output Real data "Output data";

            external "C" data = analogOut(kernelHandle, taskName, currTime);

        end analogOut;

        end Kernel;

        class Network "External C interface of network simulator"
        extends ExternalObject;

        encapsulated function constructor "Initialize simulated network bus"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

          input Real params[:] "General parameter vector";
          input Real schedule[:] "Schedule for TDMA";
          input Real systemmatrix[:,:] "System matrix for TTCAN";
          input Real statschedule[:] "Static schedule for FlexRay";
          input Real dymschedule[:] "Dynamic schedule for FlexRay";
          output Network networkHandle "Handle to network simulator object";

          external "C" networkHandle = Network_Init(params, size(params,1), schedule, size(schedule,1),
                                             systemmatrix, size(systemmatrix,1), size(systemmatrix,2),
                                             statschedule, size(statschedule,1),
                                             dymschedule, size(dymschedule,1));

          annotation (Include="#include \"./Extras/C-Sources/TrueTime/network.c\"");
        end constructor;

        encapsulated function destructor "Terminate simulated network bus"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

          input Network networkHandle "Handle to network simulator object";

          external "C" Network_Terminate(networkHandle);

        end destructor;

          encapsulated function runNetwork "Run the network simulator instance"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

            input Network networkHandle "Handle to network simulator object";
            input Real currTime "Current time";

            external "C" runNetwork(networkHandle, currTime);

          end runNetwork;

          encapsulated function getNextHitNetwork
            "Get next event time for network simulator"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

            input Network networkHandle "Handle to network simulator object";
            input Real currTime "Current time";
            output Real nextT "Next event time";

            external "C" nextT = getNextHitNetwork(networkHandle, currTime);

          end getNextHitNetwork;

          encapsulated function getNwSchedule "Get the network schedule"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

            input Network networkHandle "Handle to network simulator object";
            input Integer numberOfFrames "Number of frames";
            input Real currTime "Current time";
            output Real transmissionSchedule[numberOfFrames];

            external "C" getNwSchedule(networkHandle, transmissionSchedule, numberOfFrames);

          end getNwSchedule;

          encapsulated function transmitFrame "Transmit a network frame"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

            input Network networkHandle "Handle to network simulator object";
            input Integer frameID "Frame identifier";
            input Real data "Frame data";
            input Integer frameSize "Frame size (bits)";
            input Integer framePriority "Frame priority";
            input Real currTime "Current time";
            output Integer errNo "To indicate success";

            external "C" errNo = transmitFrame(networkHandle, frameID, frameID, data, frameSize, framePriority, currTime);

          end transmitFrame;

        encapsulated function receiveFrame "Receive a network frame"
          import
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network;

            input Network networkHandle "Handle to network simulator object";
            input Integer frameID "Frame identifier";
            input Real currTime "Current time";
            input Real u "Dummy input for correct incidence";
            output Real data "Received data";

            external "C" data = receiveFrame(networkHandle, frameID, currTime);

        end receiveFrame;

        end Network;
      end ExternalC;

      type SchedulingPolicyEnum = enumeration(
          prioFP "Fixed-priority scheduling",
          prioRM "Rate-monotonic scheduling",
          prioDM "Deadline-monotonic scheduling",
          prioEDF "Earliest-deadline-first scheduling")
        "Enumeration to define scheduling policies";

      type MacPolicyEnum = enumeration(
          Ethernet,
          CAN,
          TDMA,
          TTCAN,
          FlexRay) "Enumeration to define Media Access Control policies";
      block ControllerTask "Truetime simulation: Controller task"
      extends Modelica_Synchronous.WorkInProgress.Icons.CommunicationIcon;

        parameter String taskName = "DefaultTask" "Task name" annotation (Dialog(group="Controller task parameters"));
        parameter Real executionTimeCalculate = 0.002
          "Execution time to calculate outputs"                                             annotation (Dialog(group="Controller task parameters"));
        parameter Real executionTimeUpdate = -1
          "Execution time to update states"                                       annotation (Dialog(group="Controller task parameters"));

        parameter
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel
          kernelHandle "Handle to kernel simulator object" annotation(Dialog(group="Kernel simulator"));

        Modelica.Blocks.Interfaces.RealInput u
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));
        Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(
              transformation(
              extent={{-20,-20},{20,20}},
              rotation=90,
              origin={0,-120})));

      protected
        Real err;
        Real set_ctrl;

      equation
        when trigger then
          err =
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel.createJob(
                    kernelHandle,
                    taskName,
                    executionTimeCalculate,
                    executionTimeUpdate,
                    time);
        end when;
        set_ctrl =
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel.setControl(
                  kernelHandle,
                  taskName,
                  u,
                  time);
        y =
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel.analogOut(
                  kernelHandle,
                  taskName,
                  time,
                  u);

          annotation (Placement(transformation(extent={{100,-50},{120,-30}})),
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics),
          Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                  {100,100}}), graphics={
              Text(
                extent={{-96,-72},{94,-92}},
                lineColor={0,0,255},
                textString="Controller task"),
              Text(
                extent={{-80,88},{78,70}},
                lineColor={0,0,255},
                textString="TrueTime simulation"),
              Rectangle(
                extent={{-72,34},{-46,20}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-46,8},{-22,-6}},
                lineColor={255,0,0},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-22,34},{-4,20}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-4,-18},{26,-32}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{26,8},{48,-6}},
                lineColor={255,0,0},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{48,34},{68,20}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-46,20},{-46,8}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{-22,20},{-22,8}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{-4,18},{-4,-18}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{26,-6},{26,-18}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{48,20},{48,8}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{-80,-40},{76,-40}},
                color={0,0,0},
                smooth=Smooth.None),
              Line(
                points={{-80,-38},{-80,-42}},
                color={0,0,0},
                smooth=Smooth.None),
              Line(
                points={{76,-38},{84,-40},{76,-42},{76,-38}},
                color={0,0,0},
                smooth=Smooth.None)}));
      end ControllerTask;

      block TransmitReceive "TrueTime simulation: Transmit/Receive"
      extends Modelica_Synchronous.WorkInProgress.Icons.CommunicationIcon;

        parameter Integer frameDataSize = 32 "Frame size (bits)" annotation (Dialog(group="Transmission parameters"));
        parameter Integer frameID = 1 "Frame ID (1,...,numberOfFrames)" annotation (Dialog(group="Transmission parameters"));
        parameter Integer framePriority = frameID
          "Priority of frame (for CAN and TTCAN)"                                     annotation (Dialog(group="Transmission parameters"));
        parameter
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network
          networkHandle "Handle to network simulator object" annotation(Dialog(group="Network simulator"));

        Modelica.Blocks.Interfaces.RealInput u
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));
        Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(
              transformation(
              extent={{-20,-20},{20,20}},
              rotation=90,
              origin={0,-120})));

      protected
        Real err;
      equation
        when trigger then
          err =
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network.transmitFrame(
                    networkHandle,
                    frameID,
                    u,
                    frameDataSize,
                    framePriority,
                    time);
        end when;
        y =
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network.receiveFrame(
                  networkHandle,
                  frameID,
                  time,
                  u);

      annotation (
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics),
          Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                               graphics={
              Text(
                extent={{-96,-72},{94,-92}},
                lineColor={0,0,255},
                textString="Transmit-Receive"),
              Line(
                points={{-72,-2},{68,-2}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{-42,-28},{-42,-2}},
                color={255,0,0},
                smooth=Smooth.None),
              Rectangle(extent={{-58,-28},{-26,-52}}, lineColor={255,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={215,215,215}),
              Rectangle(extent={{10,-28},{42,-52}}, lineColor={0,0,255},
                fillPattern=FillPattern.Solid,
                fillColor={215,215,215}),
              Line(
                points={{26,-28},{26,-2}},
                color={0,0,255},
                smooth=Smooth.None),
              Rectangle(extent={{-24,48},{8,24}}, lineColor={255,0,0},
                fillPattern=FillPattern.Solid,
                fillColor={215,215,215}),
              Line(
                points={{-8,-2},{-8,24}},
                color={255,0,0},
                smooth=Smooth.None),
              Line(
                points={{-42,-2},{-8,-2}},
                color={255,0,0},
                smooth=Smooth.None),
              Text(
                extent={{-80,88},{78,70}},
                lineColor={0,0,255},
                textString="TrueTime simulation"),
              Line(
                points={{-8,24},{-10,16},{-6,16},{-8,24}},
                color={255,0,0},
                smooth=Smooth.None),
              Line(
                points={{-42,-2},{-44,-10},{-40,-10},{-42,-2}},
                color={255,0,0},
                smooth=Smooth.None)}));
      end TransmitReceive;

      block ControllerNode
        "TrueTime simulation: Controller task with network interface"
      extends Modelica_Synchronous.WorkInProgress.Icons.CommunicationIcon;

        parameter String taskName = "DefaultTask" "Task name" annotation (Dialog(group="Controller task parameters"));
        parameter Real executionTimeCalculate = 0.002
          "Execution time to calculate outputs"                                             annotation (Dialog(group="Controller task parameters"));
        parameter Real executionTimeUpdate = -1
          "Execution time to update states"                                       annotation (Dialog(group="Controller task parameters"));

        parameter
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel
          kernelHandle "Handle to kernel simulator object" annotation(Dialog(group="Kernel simulator"));

        parameter Integer frameDataSize = 32 "Frame size (bits)" annotation (Dialog(group="Transmission parameters"));
        parameter Integer frameID = 1 "Frame ID (1,...,numberOfFrames)" annotation (Dialog(group="Transmission parameters"));
        parameter Integer framePriority = frameID
          "Priority of frame (for CAN and TTCAN)"                                     annotation (Dialog(group="Transmission parameters"));
        parameter
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network
          networkHandle "Handle to network simulator object" annotation(Dialog(group="Network simulator"));

        Modelica.Blocks.Interfaces.RealInput u
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
        Modelica.Blocks.Interfaces.RealOutput y
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));
        Modelica.Blocks.Interfaces.BooleanInput trigger annotation (Placement(
              transformation(
              extent={{-20,-20},{20,20}},
              rotation=90,
              origin={0,-120})));

      protected
        Real err;
        Real set_ctrl;

      equation
        when trigger then
          err =
            Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel.createJobNw(
                    kernelHandle,
                    taskName,
                    executionTimeCalculate,
                    executionTimeUpdate,
                    networkHandle,
                    frameDataSize,
                    frameID,
                    framePriority,
                    time);
        end when;
        set_ctrl =
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Kernel.setControl(
                  kernelHandle,
                  taskName,
                  u,
                  time);
        y =
          Modelica_Synchronous.WorkInProgress.Incubate.TrueTime.ExternalC.Network.receiveFrame(
                  networkHandle,
                  frameID,
                  time,
                  u);

      annotation (
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics),
          Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                  {100,100}}), graphics={
              Text(
                extent={{-96,-72},{94,-92}},
                lineColor={0,0,255},
                textString="Controller node"),
              Text(
                extent={{-80,88},{78,70}},
                lineColor={0,0,255},
                textString="TrueTime simulation"),
              Rectangle(extent={{-28,48},{16,20}},lineColor={0,0,255},
                fillPattern=FillPattern.Solid,
                fillColor={215,215,215}),
              Line(
                points={{-70,-2},{70,-2}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{-40,-24},{-40,-2}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{-6,-2},{-6,20}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{28,-24},{28,-2}},
                color={0,0,255},
                smooth=Smooth.None),
              Rectangle(extent={{-60,-24},{-20,-52}},
                                                  lineColor={0,0,255},
                fillPattern=FillPattern.Solid,
                fillColor={215,215,215}),
              Rectangle(extent={{8,-24},{48,-52}},lineColor={0,0,255},
                fillPattern=FillPattern.Solid,
                fillColor={215,215,215}),
              Rectangle(
                extent={{-26,44},{-20,40}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-20,36},{-14,32}},
                lineColor={255,0,0},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-14,44},{-8,40}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-8,28},{0,24}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{0,36},{6,32}},
                lineColor={255,0,0},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{6,44},{14,40}},
                lineColor={0,0,255},
                fillColor={175,175,175},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-20,40},{-20,36}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{-14,40},{-14,36}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{-8,40},{-8,28}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{0,32},{0,28}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{6,40},{6,36}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dot)}));
      end ControllerNode;

    end TrueTime;

    package IntegerSignals
          block Limiter "Limit the range of a signal"
          extends Modelica_Synchronous.Interfaces.ClockedBlockIcon;
            parameter Integer uMax(start=1) "Upper limits of input signals";
            parameter Integer uMin= -uMax "Lower limits of input signals";
            parameter Boolean limitsAtInit = true
          "= false, if limits are ignored during initializiation (i.e., y=u)";

            Modelica.Blocks.Interfaces.IntegerInput u
          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
            Modelica.Blocks.Interfaces.IntegerOutput y
          annotation (Placement(transformation(extent={{100,-10},{120,10}})));
          equation
            assert(uMax >= uMin, "Limiter: Limits must be consistent. However, uMax (=" + String(uMax) +
                                 ") < uMin (=" + String(uMin) + ")");
            y = if u > uMax then uMax else if u < uMin then uMin else u;
            annotation (
              Documentation(info="
<HTML>
<p>
The Limiter block passes its input signal as output signal
as long as the input is within the specified upper and lower
limits. If this is not the case, the corresponding limits are passed
as output.
</p>
</HTML>
"),           Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{0,-90},{0,68}}, color={192,192,192}),
              Polygon(
                points={{0,90},{-8,68},{8,68},{0,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{68,0}}, color={192,192,192}),
              Polygon(
                points={{90,0},{68,-8},{68,8},{90,0}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,-70},{-50,-70},{50,70},{80,70}}, color={0,0,0}),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="uMax=%uMax"),
              Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
              Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{0,-60},{0,50}}, color={192,192,192}),
              Polygon(
                points={{0,60},{-5,50},{5,50},{0,60}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-60,0},{50,0}}, color={192,192,192}),
              Polygon(
                points={{60,0},{50,-5},{50,5},{60,0}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-50,-40},{-30,-40},{30,40},{50,40}}, color={0,0,0}),
              Text(
                extent={{46,-6},{68,-18}},
                lineColor={128,128,128},
                textString="u"),
              Text(
                extent={{-30,70},{-5,50}},
                lineColor={128,128,128},
                textString="y"),
              Text(
                extent={{-58,-54},{-28,-42}},
                lineColor={128,128,128},
                textString="uMin"),
              Text(
                extent={{26,40},{66,56}},
                lineColor={128,128,128},
                textString="uMax")}));
          end Limiter;

      block ComputationalDelay
      extends Modelica_Synchronous.Interfaces.PartialIntegerClockedSISO;
        parameter Integer shiftCounter(min=0,max=resolution) = 0
          "(min=0, max=resolution), computational delay = interval()*shiftCounter/resolution"
                                                                                       annotation(Dialog(group="Computational delay in seconds = interval() * shiftCounter/resolution"));
        parameter Integer resolution(min=1) = 1
          "Time quantization resolution of sample interval" annotation(Dialog(group="Computational delay in seconds = interval() * shiftCounter/resolution"));

      protected
       Integer ubuf;
      equation
       assert(resolution >= shiftCounter, "The maximal computational delay has the length of one sample interval, however a larger value than that was set");
       ubuf = if shiftCounter == resolution then previous(u) else u;
       y = shiftSample(ubuf, shiftCounter, resolution);
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                  -100},{100,100}}), graphics));
      end ComputationalDelay;

      block UniformNoise
        extends Modelica_Synchronous.Interfaces.PartialIntegerNoise;
        parameter Integer noiseMin=-1 "Lower limit of noise band";
        parameter Integer noiseMax=1 "Upper limit of noise band";
        parameter Integer firstSeed[3](each min=0, each max=255) = {23,87,187}
          "Integer[3] defining random sequence; required element range: 0..255";
      protected
        Integer seedState[3] "State of seed" annotation(Hide=true);
        Real noise "Noise in the range 0..1" annotation(Hide=true);
      equation
          (noise,seedState) =
            Modelica_Synchronous.RealSignals.SampleAndHolds.Utilities.Internal.random(
                                                             previous(seedState));
          y = u + noiseMin + integer((noiseMax - noiseMin)*noise + 0.5);
        annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics));
      end UniformNoise;

      block FractionalDelay
        "Delay clocked input signal for a fractional multiple of the sample period"
      extends Modelica_Synchronous.Interfaces.PartialIntegerClockedSISO;

        parameter Integer shift(min=0) = 0
          "Delay = interval() * shift/resolution";

        parameter Integer resolution(min=1) = 1
          "Time quantization resolution of sample interval";
        final parameter Integer n = div(shift,resolution);
      protected
        Integer u_buffer[n+1](each start=0)
          "The previous values of the inputs; u_last[1] = u, u_last[2] = previous(u_last[1]); u_last[3] = previous(u_last[2])";
        Boolean first(start=true) "Used to identify the first clock tick";
      equation
       first = false;

       u_buffer = if previous(first) then fill(u,n+1) else
         cat(1, {u}, previous(u_buffer[1:n]));

       y = shiftSample(u_buffer[n+1], shift, resolution);

        annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                  -100},{100,100}}), graphics), DymolaStoredErrors,
          Icon(graphics={
              Line(
                points={{-100,0},{-80,0},{-80,40},{-20,40},{-20,-40},{40,-40},{40,0},{
                    100,0}},
                color={215,215,215},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{-100,0},{-50,0},{-50,40},{10,40},{10,-40},{70,-40},{70,-0.3125},
                    {100,0}},
                pattern=LinePattern.Dot,
                smooth=Smooth.None,
                color={255,128,0}),
              Text(
                extent={{4,-102},{4,-142}},
                lineColor={0,0,0},
                textString="%shift/%resolution"),
              Ellipse(
                extent={{-90,50},{-70,30}},
                lineColor={255,128,0},
                fillColor={255,128,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-30,-30},{-10,-50}},
                lineColor={255,128,0},
                fillColor={255,128,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{30,10},{50,-10}},
                lineColor={255,128,0},
                fillColor={255,128,0},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-60,50},{-40,30}},
                lineColor={255,128,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{0,-30},{20,-50}},
                lineColor={255,128,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{60,10},{80,-10}},
                lineColor={255,128,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end FractionalDelay;
    end IntegerSignals;

    package BooleanSignals
      block ComputationalDelay
      extends Modelica_Synchronous.Interfaces.PartialBooleanClockedSISO;
        parameter Integer shiftCounter(min=0,max=resolution) = 0
          "(min=0, max=resolution), computational delay = interval()*shiftCounter/resolution"
                                                                                       annotation(Dialog(group="Computational delay in seconds = interval() * shiftCounter/resolution"));
        parameter Integer resolution(min=1) = 1
          "Time quantization resolution of sample interval" annotation(Dialog(group="Computational delay in seconds = interval() * shiftCounter/resolution"));

      protected
       Boolean ubuf;
      equation
       assert(resolution >= shiftCounter, "The maximal computational delay has the length of one sample interval, however a larger value than that was set");
       ubuf = if shiftCounter == resolution then previous(u) else u;
       y = shiftSample(ubuf, shiftCounter, resolution);
        annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                  -100},{100,100}}), graphics));
      end ComputationalDelay;

      block FractionalDelay
        "Delay clocked input signal for a fractional multiple of the sample period"
      extends Modelica_Synchronous.Interfaces.PartialBooleanClockedSISO;

        parameter Integer shift(min=0) = 0
          "Delay = interval() * shift/resolution";

        parameter Integer resolution(min=1) = 1
          "Time quantization resolution of sample interval";
        final parameter Integer n = div(shift,resolution);
      protected
        Boolean u_buffer[n+1](each start=false)
          "The previous values of the inputs; u_last[1] = u, u_last[2] = previous(u_last[1]); u_last[3] = previous(u_last[2])";
        Boolean first(start=true) "Used to identify the first clock tick";
      equation
       first = false;

       u_buffer = if previous(first) then fill(u,n+1) else
         cat(1, {u}, previous(u_buffer[1:n]));

       y = shiftSample(u_buffer[n+1], shift, resolution);

        annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                  -100},{100,100}}), graphics), DymolaStoredErrors,
          Icon(graphics={
              Line(
                points={{-100,0},{-80,0},{-80,40},{-20,40},{-20,-40},{40,-40},{40,0},{
                    100,0}},
                color={215,215,215},
                smooth=Smooth.None,
                pattern=LinePattern.Dot),
              Line(
                points={{-100,0},{-50,0},{-50,40},{10,40},{10,-40},{70,-40},{70,-0.3125},
                    {100,0}},
                pattern=LinePattern.Dot,
                smooth=Smooth.None,
                color={255,0,255}),
              Text(
                extent={{4,-102},{4,-142}},
                lineColor={0,0,0},
                textString="%shift/%resolution"),
              Ellipse(
                extent={{-90,50},{-70,30}},
                lineColor={255,0,255},
                fillColor={255,0,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-30,-30},{-10,-50}},
                lineColor={255,0,255},
                fillColor={255,0,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{30,10},{50,-10}},
                lineColor={255,0,255},
                fillColor={255,0,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-60,50},{-40,30}},
                lineColor={255,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{0,-30},{20,-50}},
                lineColor={255,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{60,10},{80,-10}},
                lineColor={255,0,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end FractionalDelay;
    end BooleanSignals;

    package RealSignals
      block CommunicationDelaySpecifiedInSeconds
        "NOT VALID MODELICA 3.3! Might be nice to provide a block that allows to specify delay in seconds instead of indirectly as fractions of the current rate"
      extends Modelica_Synchronous.Interfaces.PartialRealClockedSISO;
      extends Modelica_Synchronous.WorkInProgress.Icons.BlockNotReady;
        parameter Modelica.SIunits.Time communicationDelayTime(min=0)=0
          "Time delay due to communication";
        /* Modelica 3.3 doesn't allow the following code since interval(..) has a non-parameter variability! */

      /* Statement as comment, in order that check does not produce an error
protected
  parameter Integer shiftSampleParam[2] = realDelay2shiftSampleParameters(communicationDelayTime, interval(u));
equation
  y = shiftSample(u, shiftSampleParam[1], shiftSampleParam[2]);
  */
      equation
        y = 0;

        annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                  -100},{100,100}}), graphics), DymolaStoredErrors);
      end CommunicationDelaySpecifiedInSeconds;

      function realDelay2shiftSampleParameters
        "Beta Warning: Function might be not robust for all kind of (seemingly) valid input"
      import Modelica.Utilities.Strings.*;
      input Real delay "Delay in seconds";
      input Real rate "Sample rate in seconds";
      output Integer param[2]
          "Arguments to shiftSample(..). param[1]: shiftCounter, param[2]: resolution";
      protected
        Integer index;
        Integer iDecPoint;
        Integer resolution;
        Integer shiftCounter;
        Real delayRateRatio = delay/rate;
        Real shift;
        String number = realString(delayRateRatio, 1, 10) "10 digits precision";
      algorithm
        // truncate all trailing zeros
        index := findLast(number, "0");
        while index == length(number) loop
          number := substring(number,1, length(number) -1);
          index := findLast(number, "0");
        end while;

        // Compute fitting resolution and shiftCounter
        iDecPoint :=findLast(number, ".");
        resolution := length(number) - iDecPoint;
        shift := delayRateRatio * 10^resolution;
        shiftCounter := integer(floor(shift + 0.5));

        param := {shiftCounter, resolution};
      end realDelay2shiftSampleParameters;
    end RealSignals;

    block PID "Discrete-time PID controller"
      extends Modelica_Synchronous.Interfaces.PartialRealClockedSISO;
      parameter Real k = 1 "Gain of PID controller";
      parameter Real Ti(min=Modelica.Constants.small) = 0.5
        "Time constant of integrator part";
      parameter Real Td(min=0) = 0.1 "Time constant of derivative part";
      parameter Real y_start=0 "Initial value of output"
        annotation (Dialog(group="Initialization"));
    protected
      Real u_pre(start=0);
      Real T = interval(u);
    equation
      when Clock() then
        u_pre = previous(u);
        y = previous(y) + k*( (1 + T/Ti + Td/T)*u - (1 + 2*Td/T)*u_pre + Td/T*previous(u_pre));
      end when;

      annotation (defaultComponentName="PI1",
           Icon(graphics={
            Polygon(
              points={{90,-82},{68,-74},{68,-90},{90,-82}},
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Line(points={{-90,-82},{82,-82}}, color={192,192,192}),
            Line(points={{-80,76},{-80,-92}}, color={192,192,192}),
            Polygon(
              points={{-80,90},{-88,68},{-72,68},{-80,90}},
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-80,-82},{-80,48},{-32,48},{-32,-10},{16,-10},{16,22},{64,22}},
              color={0,0,127},
              smooth=Smooth.None,
              pattern=LinePattern.Dot),
            Text(
              extent={{-30,-4},{82,-58}},
              lineColor={192,192,192},
              textString="PID"),
            Ellipse(
              extent={{-39,-3},{-27,-15}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{9,28},{21,16}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{58,27},{70,15}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-87,55},{-75,43}},
              lineColor={0,0,127},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-140,-140},{140,-100}},
              lineColor={0,0,0},
              textString="Ti=%Ti, Td=%Td"),
            Text(
              extent={{-140,60},{140,100}},
              lineColor={0,0,0},
              textString="k=%k")}),
        Documentation(info="<html>
<p>
This block defines a text-book version of a discrete-time PID controller by the formula:
</p>
<pre>
// Transfer function form:
   G(z) = (b0*z^2 + b1*z + b2) / (z^2 - z);
   b0 = k*(1 + T/Ti + Td/T)
   b1 = -k*(1 + 2*Td/T)
   b2 = k*Td/T       
</pre>
<p>
where k is the gain of the controller, Ti is the time constant of the integrative part, Td is the time constant of the derivative part, and T is the sample period.
</p>

<p>
This discrete-time form has been derived from the continuous-time
form of a PID controller by using the backward rectangular approximation (also called backward euler method or right-hand approximation) between the  s- and z- domain:
</p>
<pre>
   s = (z - 1)/(h*z)       
</pre>
</html>"));
    end PID;

    model TestPIDController
      import Modelica_Synchronous;
     extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-36,-16},{-24,-4}})));
      Modelica_Synchronous.WorkInProgress.Incubate.PID
                               PI1
        annotation (Placement(transformation(extent={{28,0},{48,20}})));
      Modelica.Blocks.Sources.Step step(startTime=0.19)
        annotation (Placement(transformation(extent={{-82,0},{-62,20}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked sample1
        annotation (Placement(transformation(extent={{-8,4},{4,16}})));
      Modelica_LinearSystems2.Controller.Sampler sampler(blockType=
            Modelica_LinearSystems2.Controller.Types.BlockTypeWithGlobalDefault.Discrete)
        annotation (Placement(transformation(extent={{-38,-60},{-18,-40}})));
      inner Modelica_LinearSystems2.Controller.SampleClock sampleClock(
        blockType=Modelica_LinearSystems2.Controller.Types.BlockType.Discrete,
        methodType=Modelica_LinearSystems2.Types.Method.ExplicitEuler,
        sampleTime=0.1)
        annotation (Placement(transformation(extent={{60,68},{80,88}})));
      Modelica_LinearSystems2.Controller.PID pID(
        Ti=0.5,
        Td=0.1,
        blockType=Modelica_LinearSystems2.Controller.Types.BlockTypeWithGlobalDefault.Discrete,
        pidRep=Modelica_LinearSystems2.Controller.Types.PID_representation.timeConstants,
        initType=Modelica_LinearSystems2.Controller.Types.InitWithGlobalDefault.NoInit,
        methodType=Modelica_LinearSystems2.Controller.Types.MethodWithGlobalDefault.ExplicitEuler,
        Nd=1) annotation (Placement(transformation(extent={{8,-60},{28,-40}})));

    equation
      connect(step.y, sample1.u) annotation (Line(
          points={{-61,10},{-9.2,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.clock, periodicRealClock.y) annotation (Line(
          points={{-2,2.8},{-2,-10},{-23.4,-10}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample1.y, PI1.u) annotation (Line(
          points={{4.6,10},{26,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.u, step.y) annotation (Line(
          points={{-40,-50},{-48,-50},{-48,10},{-61,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.y, pID.u) annotation (Line(
          points={{-17,-50},{6,-50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics={Text(
              extent={{-92,66},{96,18}},
              lineColor={0,0,255},
              textString="No direct comparison of PID blocks possible, since different discretization method used!
=> Hard to say whether clocked PID is \"correct\".")}));
    end TestPIDController;
    annotation (preferredView="info", Documentation(info="<html>
</html>"));
  end Incubate;

  package Icons

    block DoesNotTranslate

      annotation (Icon(graphics={                   Text(
              extent={{-100,100},{100,-100}},
              lineColor={255,0,0},
              textString="!"),   Rectangle(extent={{-100,100},{100,-100}},
                                                                         lineColor=
                  {255,0,0})}));
    end DoesNotTranslate;

    block OperatesOnlyPartially

      annotation (Icon(graphics={Rectangle(extent={{-100,100},{100,-100}},
                                                                         lineColor=
                  {255,128,0}),                     Text(
              extent={{-100,100},{100,-100}},
              lineColor={255,128,0},
              textString="!")}));
    end OperatesOnlyPartially;

    partial package PackageNotReady

      annotation (Icon(graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={127,0,0},
              pattern=LinePattern.Dash,
              lineThickness=0.5)}));
    end PackageNotReady;

    partial block BlockNotReady

      annotation (Icon(graphics={Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={127,0,0},
              pattern=LinePattern.Dash,
              lineThickness=0.5)}));
    end BlockNotReady;

    partial block CommunicationIcon
      "Icon for a port block that communicates a signal"

      annotation (
           Icon(coordinateSystem(
                 preserveAspectRatio=true,
                 extent={{-100,-100},{100,100}},
                 initialScale=0.06), graphics={Rectangle(
              extent={{-100,-100},{100,100}},
              lineColor={0,0,127},
              fillColor={240,240,240},
              fillPattern=FillPattern.Solid,
              borderPattern=BorderPattern.Raised), Text(
              extent={{-150,110},{150,150}},
              lineColor={0,0,255},
              fillColor={85,85,255},
              fillPattern=FillPattern.Solid,
              textString="%name")}));

    end CommunicationIcon;
  end Icons;

  package Tests "Package that contains test"
    model TestFIR_1
      parameter Integer order=3;
      final parameter Real a[:]=fill(1/order,order);
      Modelica_Synchronous.RealSignals.Periodic.FIRbyCoefficients
                                 fIRbyCoefficients(a=a)
        annotation (Placement(transformation(extent={{-20,20},{0,40}})));
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0.1)
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-44,24},{-32,36}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.01)
        annotation (Placement(transformation(extent={{-74,-14},{-62,-2}})));

    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-59,30},{-45.2,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, fIRbyCoefficients.u) annotation (Line(
          points={{-31.4,30},{-22,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-61.4,-8},{-38,-8},{-38,22.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestFIR_1;

    model TestFIR
      extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;
      parameter Integer order=3;
      final parameter Real a[:]=fill(1/order,order);
      Modelica_Synchronous.RealSignals.Periodic.FIRbyCoefficients
                                 fIRbyCoefficients(a=a)
        annotation (Placement(transformation(extent={{-20,20},{0,40}})));
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0.1)
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-44,24},{-32,36}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.01)
        annotation (Placement(transformation(extent={{-74,-14},{-62,-2}})));
      Modelica_LinearSystems2.Controller.FilterFIR filter(
        blockType=Modelica_LinearSystems2.Controller.Types.BlockTypeWithGlobalDefault.Discrete,
        specType=Modelica_LinearSystems2.Controller.Types.FIRspec.Coefficients,
        a=a,
        sampleFactor=1)
        annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

      inner Modelica_LinearSystems2.Controller.SampleClock sampleClock(blockType=
            Modelica_LinearSystems2.Controller.Types.BlockType.Discrete,
          sampleTime=0.01)
        annotation (Placement(transformation(extent={{40,-20},{60,0}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-59,30},{-45.2,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, fIRbyCoefficients.u) annotation (Line(
          points={{-31.4,30},{-22,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-61.4,-8},{-38,-8},{-38,22.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sine.y, filter.u) annotation (Line(
          points={{-59,30},{-50,30},{-50,-30},{-22,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics={Text(
              extent={{-94,88},{94,40}},
              lineColor={0,0,255},
              textString=
                  "Needs \"Evaluate Parameters\"=true in Translation settings in order to compile.")}));
    end TestFIR;

    block TestFIR_Step
      extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;
      parameter Integer na=4;
      final parameter Real a[:]=fill(1/na,na);
      inner Modelica_LinearSystems2.Controller.SampleClock sampleClock(blockType=
            Modelica_LinearSystems2.Controller.Types.BlockType.Discrete, sampleTime=
           0.1)
        annotation (Placement(transformation(extent={{20,-34},{40,-14}})));
      Modelica_LinearSystems2.Controller.FilterFIR filter1(
        blockType=Modelica_LinearSystems2.Controller.Types.BlockTypeWithGlobalDefault.Discrete,
        specType=Modelica_LinearSystems2.Controller.Types.FIRspec.Coefficients,
        a=a,
        sampleFactor=1)
        annotation (Placement(transformation(extent={{-20,-34},{0,-14}})));
      Modelica.Blocks.Sources.Step step(startTime=0.4999, offset=0.5)
        annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
      Modelica_Synchronous.RealSignals.Periodic.FIRbyCoefficients
                                 fIRbyCoefficients(a=a)
        annotation (Placement(transformation(extent={{-20,6},{0,26}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-44,10},{-32,22}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-74,-40},{-62,-28}})));
      Modelica.Blocks.Sources.Step step1(                 offset=0.5, startTime=0.5)
        annotation (Placement(transformation(extent={{-80,-94},{-60,-74}})));
      Modelica_LinearSystems2.Controller.FilterFIR filter2(
        blockType=Modelica_LinearSystems2.Controller.Types.BlockTypeWithGlobalDefault.Discrete,
        specType=Modelica_LinearSystems2.Controller.Types.FIRspec.Coefficients,
        a=a,
        sampleFactor=1)
        annotation (Placement(transformation(extent={{-20,-94},{0,-74}})));
      Modelica_Synchronous.RealSignals.Periodic.MovingAverage
                             movingAverage(n=na)
        annotation (Placement(transformation(extent={{-20,46},{0,66}})));
    equation
      connect(step.y,filter1. u) annotation (Line(
          points={{-59,16},{-52,16},{-52,-24},{-22,-24}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y,fIRbyCoefficients. u) annotation (Line(
          points={{-31.4,16},{-22,16}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y,sample1. clock) annotation (Line(
          points={{-61.4,-34},{-38,-34},{-38,8.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(step.y, sample1.u) annotation (Line(
          points={{-59,16},{-45.2,16}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(step1.y, filter2.u) annotation (Line(
          points={{-59,-84},{-22,-84}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, movingAverage.u) annotation (Line(
          points={{-31.4,16},{-30,16},{-30,56},{-22,56}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics={Text(
              extent={{-92,110},{96,62}},
              lineColor={0,0,255},
              textString=
                  "Needs \"Evaluate Parameters\"=true in Translation settings in order to compile.")}));
    end TestFIR_Step;

    block TestFIR_Step2
      extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;

      inner Modelica_LinearSystems2.Controller.SampleClock sampleClock(blockType=
            Modelica_LinearSystems2.Controller.Types.BlockType.Discrete, sampleTime=
           0.1)
        annotation (Placement(transformation(extent={{20,0},{40,20}})));
      Modelica.Blocks.Sources.Step step(startTime=0.4999, offset=0.5)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-44,44},{-32,56}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-62,-6},{-50,6}})));
      Modelica.Blocks.Sources.Step step1(                 offset=0.5, startTime=0.5)
        annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
      Modelica_LinearSystems2.Controller.FilterFIR filter2(
        blockType=Modelica_LinearSystems2.Controller.Types.BlockTypeWithGlobalDefault.Discrete,
        sampleFactor=1,
        specType=Modelica_LinearSystems2.Controller.Types.FIRspec.Window,
        f_cut=2,
        window=Modelica_LinearSystems2.Controller.Types.Window.Rectangle,
        order=3)
        annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
      Modelica_Synchronous.RealSignals.Periodic.FIRbyWindow
                           FIR1(
        filterType=Modelica_Synchronous.Types.FIR_FilterType.LowPass,
        f_cut=2,
        window=Modelica_Synchronous.Types.FIR_Window.Rectangle,
        order=3)
        annotation (Placement(transformation(extent={{-20,40},{0,60}})));
    equation
      connect(periodicRealClock.y,sample1. clock) annotation (Line(
          points={{-49.4,0},{-38,0},{-38,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(step.y, sample1.u) annotation (Line(
          points={{-59,50},{-45.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(step1.y, filter2.u) annotation (Line(
          points={{-59,-50},{-22,-50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, FIR1.u) annotation (Line(
          points={{-31.4,50},{-22,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics={Text(
              extent={{-94,106},{94,58}},
              lineColor={0,0,255},
              textString=
                  "Needs \"Evaluate Parameters\"=true in Translation settings in order to compile.")}));
    end TestFIR_Step2;

    block TestFIR_Step2b
      extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;

      Modelica.Blocks.Sources.Step step(startTime=0.4999, offset=0.5)
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-44,44},{-32,56}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-62,-6},{-50,6}})));
      Modelica_Synchronous.RealSignals.Periodic.FIRbyWindow
                           FIR1(
        filterType=Modelica_Synchronous.Types.FIR_FilterType.LowPass,
        f_cut=2,
        window=Modelica_Synchronous.Types.FIR_Window.Rectangle,
        order=3)
        annotation (Placement(transformation(extent={{-20,40},{0,60}})));
    equation
      connect(periodicRealClock.y,sample1. clock) annotation (Line(
          points={{-49.4,0},{-38,0},{-38,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(step.y, sample1.u) annotation (Line(
          points={{-59,50},{-45.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, FIR1.u) annotation (Line(
          points={{-31.4,50},{-22,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics={Text(
              extent={{-90,106},{98,58}},
              lineColor={0,0,255},
              textString=
                  "Needs \"Evaluate Parameters\"=true in Translation settings in order to compile.")}));
    end TestFIR_Step2b;

    model TestInterpolator

      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-94,40},{-74,60}})));
      inner Modelica_LinearSystems2.Controller.SampleClock sampleClock(blockType=
            Modelica_LinearSystems2.Controller.Types.BlockType.Discrete,
          sampleTime=0.025)
        annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-36,44},{-24,56}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-50,-6},{-38,6}})));
      Modelica_LinearSystems2.Controller.Sampler sampler(sampleFactor=4)
        annotation (Placement(transformation(extent={{-42,-60},{-22,-40}})));
      Modelica_LinearSystems2.Controller.Interpolator ls_interpolator(
          inputSampleFactor=4, meanValueFilter=true)
        annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.AssignClock
                                              assignClock1
        annotation (Placement(transformation(extent={{52,44},{64,56}})));
      Modelica_Synchronous.ClockSignals.SuperSample
                                               superSample1(factor=4)
        annotation (Placement(transformation(extent={{6,-6},{18,6}})));
      Modelica_Synchronous.WorkInProgress.Interpolator
                                               interpolator1(
        factor=4,
        inferFactor=false,
        movingAverageFilter=false)
        annotation (Placement(transformation(extent={{2,44},{14,56}})));
      Modelica_Synchronous.WorkInProgress.Interpolator
                                               interpolator2(
        movingAverageFilter=true,
        factor=4,
        inferFactor=false)
        annotation (Placement(transformation(extent={{2,18},{14,30}})));
    equation
      connect(periodicRealClock.y,sample1. clock) annotation (Line(
          points={{-37.4,0},{-30,0},{-30,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sine.y, sample1.u) annotation (Line(
          points={{-73,50},{-37.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.u, sine.y) annotation (Line(
          points={{-44,-50},{-73,-50},{-73,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.y, ls_interpolator.u) annotation (Line(
          points={{-21,-50},{-2,-50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(superSample1.u, periodicRealClock.y) annotation (Line(
          points={{4.8,0},{-37.4,0}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(superSample1.y, assignClock1.clock) annotation (Line(
          points={{18.6,0},{58,0},{58,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample1.y, interpolator1.u)
                                         annotation (Line(
          points={{-23.4,50},{0.8,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(interpolator1.y, assignClock1.u)
                                              annotation (Line(
          points={{14.6,50},{50.8,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, interpolator2.u) annotation (Line(
          points={{-23.4,50},{-12,50},{-12,24},{0.8,24}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestInterpolator;

    model TestUnitDelay
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0.15)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      inner Modelica_LinearSystems2.Controller.SampleClock sampleClock(blockType=
            Modelica_LinearSystems2.Controller.Types.BlockType.Discrete,
          sampleTime=0.1)
        annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-36,44},{-24,56}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-50,-6},{-38,6}})));
      Modelica_LinearSystems2.Controller.Sampler sampler(sampleFactor=1)
        annotation (Placement(transformation(extent={{-42,-60},{-22,-40}})));
      Modelica_LinearSystems2.Controller.UnitDelay ls_unitDelay(blockType=
            Modelica_LinearSystems2.Controller.Types.BlockTypeWithGlobalDefault.Discrete)
        annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
      Modelica_Synchronous.RealSignals.NonPeriodic.UnitDelay
                            UnitDelay1(y_start=0)
        annotation (Placement(transformation(extent={{0,40},{20,60}})));
    equation
      connect(periodicRealClock.y,sample1. clock) annotation (Line(
          points={{-37.4,0},{-30,0},{-30,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-37.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.u, sine.y) annotation (Line(
          points={{-44,-50},{-71,-50},{-71,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.y, ls_unitDelay.u) annotation (Line(
          points={{-21,-50},{-2,-50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, UnitDelay1.u) annotation (Line(
          points={{-23.4,50},{-2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestUnitDelay;

    model TestTransferFunction
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-36,44},{-24,56}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-50,-6},{-38,6}})));
      Modelica.Blocks.Discrete.Sampler sampler
        annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
      Modelica.Blocks.Discrete.TransferFunction transferFunction(samplePeriod=
            0.1, a={1,0.5})
        annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
      Modelica_Synchronous.RealSignals.Periodic.TransferFunction
                                transferFunction1(a={1,0.5})
        annotation (Placement(transformation(extent={{0,40},{20,60}})));
    equation
      connect(periodicRealClock.y,sample1. clock) annotation (Line(
          points={{-37.4,0},{-30,0},{-30,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-37.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.u, sine.y) annotation (Line(
          points={{-52,-30},{-64,-30},{-64,50},{-71,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.y, transferFunction.u) annotation (Line(
          points={{-29,-30},{-2,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, transferFunction1.u) annotation (Line(
          points={{-23.4,50},{-2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestTransferFunction;

    model TestStateSpace
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-50,-6},{-38,6}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-34,44},{-22,56}})));
      Modelica.Blocks.Discrete.StateSpace stateSpace1(
        samplePeriod=0.1,
        A=[1],
        B=[1],
        C=[1],
        D=[1]) annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
      Modelica.Blocks.Discrete.Sampler sampler
        annotation (Placement(transformation(extent={{-44,-40},{-24,-20}})));
      Modelica_Synchronous.RealSignals.Periodic.StateSpace
                          stateSpace(
        A=[1],
        B=[1],
        C=[1],
        D=[1]) annotation (Placement(transformation(extent={{0,40},{20,60}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-35.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-37.4,0},{-28,0},{-28,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sampler.y, stateSpace1.u[1]) annotation (Line(
          points={{-23,-30},{-2,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sampler.u, sine.y) annotation (Line(
          points={{-46,-30},{-62,-30},{-62,50},{-71,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, stateSpace.u[1]) annotation (Line(
          points={{-21.4,50},{-2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestStateSpace;

    model TestShiftSample

      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-50,-6},{-38,6}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-34,44},{-22,56}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.ShiftSample
                                              shiftSample1(shiftCounter=3,
          resolution=2)
        annotation (Placement(transformation(extent={{6,44},{18,56}})));
      Modelica.Blocks.Math.Add add
        annotation (Placement(transformation(extent={{40,20},{60,40}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.ShiftSample
                                              shiftSample2(shiftCounter=3,
          resolution=2)
        annotation (Placement(transformation(extent={{10,18},{22,30}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-35.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-37.4,0},{-28,0},{-28,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample1.y, shiftSample1.u) annotation (Line(
          points={{-21.4,50},{4.8,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(shiftSample1.y, add.u1) annotation (Line(
          points={{18.6,50},{28,50},{28,36},{38,36}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(shiftSample2.y, add.u2) annotation (Line(
          points={{22.6,24},{38,24}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(shiftSample2.u, sample1.y) annotation (Line(
          points={{8.8,24},{-6,24},{-6,50},{-21.4,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end TestShiftSample;

    model TestBackSample
      extends Modelica_Synchronous.WorkInProgress.Icons.DoesNotTranslate;
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-48,2},{-36,14}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-34,44},{-22,56}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.ShiftSample
                                              shiftSample1(resolution=2,
          shiftCounter=1)
        annotation (Placement(transformation(extent={{6,44},{18,56}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.BackSample
                                             backSample1(backCounter=1,
          resolution=2)
        annotation (Placement(transformation(extent={{6,-20},{18,-8}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.BackSample
                                             backSample2(
        backCounter=1,
        resolution=2,
        y_start=0.1)
        annotation (Placement(transformation(extent={{34,44},{46,56}})));
      Modelica.Blocks.Math.Add add
        annotation (Placement(transformation(extent={{68,24},{88,44}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.BackSample
                                             backSample3(
        backCounter=1,
        resolution=2,
        y_start=0.1)
        annotation (Placement(transformation(extent={{34,10},{46,22}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-35.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-35.4,8},{-28,8},{-28,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample1.y, shiftSample1.u) annotation (Line(
          points={{-21.4,50},{4.8,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(backSample1.u, sample1.y) annotation (Line(
          points={{4.8,-14},{-8,-14},{-8,50},{-21.4,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(backSample2.u, shiftSample1.y) annotation (Line(
          points={{32.8,50},{18.6,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(backSample3.u, shiftSample1.y) annotation (Line(
          points={{32.8,16},{26,16},{26,50},{18.6,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(backSample2.y, add.u1) annotation (Line(
          points={{46.6,50},{56,50},{56,40},{66,40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(backSample3.y, add.u2) annotation (Line(
          points={{46.6,16},{56,16},{56,28},{66,28}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics), Icon(graphics));
    end TestBackSample;

    model TestClockedRealToSquare
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-50,-6},{-38,6}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-34,44},{-22,56}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.Utilities.ClockedRealToBooleanSquareHold
        ClockedRealToSquare
        annotation (Placement(transformation(extent={{-4,40},{16,60}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-35.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-37.4,0},{-28,0},{-28,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample1.y, ClockedRealToSquare.u) annotation (Line(
          points={{-21.4,50},{-6,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(graphics), Icon(graphics));
    end TestClockedRealToSquare;

    model TestClockedRealToTrigger
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,20},{-72,40}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-56,4},{-44,16}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-34,24},{-22,36}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.Utilities.ClockedRealToBooleanTriggerHold
        ClockedRealToTrigger
        annotation (Placement(transformation(extent={{0,20},{20,40}})));
      Modelica.Blocks.Discrete.TriggeredSampler triggeredSampler
        annotation (Placement(transformation(extent={{40,60},{60,80}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,30},{-35.2,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-43.4,10},{-28,10},{-28,22.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample1.y, ClockedRealToTrigger.u) annotation (Line(
          points={{-21.4,30},{-2,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(triggeredSampler.u, sine.y) annotation (Line(
          points={{38,70},{-56,70},{-56,30},{-71,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(ClockedRealToTrigger.y, triggeredSampler.trigger) annotation (Line(
          points={{21,30},{50,30},{50,58.2}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics), Icon(graphics));
    end TestClockedRealToTrigger;

    model TestIntegerSamplerAndHolds

      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.AssignClock
                                                 assignClock1
        annotation (Placement(transformation(extent={{-46,64},{-34,76}})));
      Modelica.Blocks.Sources.IntegerConstant integerConstant(k=2)
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-88,-96},{-76,-84}})));
      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.Hold
                                          hold1
        annotation (Placement(transformation(extent={{-20,64},{-8,76}})));
      Modelica.Blocks.Sources.IntegerConstant integerConstant1(k=1)
        annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.SampleClocked
                                                   sample2
        annotation (Placement(transformation(extent={{-44,-16},{-32,-4}})));
      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.SampleVectorizedAndClocked
                                                                sample1(n=3)
        annotation (Placement(transformation(extent={{-44,-54},{-32,-42}})));
      Modelica.Blocks.Sources.IntegerConstant integerConstant2[3](each k=1)
        annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
      Modelica.Blocks.Sources.IntegerConstant integerConstant3[3](each k=1)
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.AssignClockVectorized
                                                           assignClock2(n=3)
        annotation (Placement(transformation(extent={{-46,24},{-34,36}})));
      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.SubSample
                                               subSample1(inferFactor=false,
          factor=2)
        annotation (Placement(transformation(extent={{-20,26},{-8,38}})));
      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.SuperSample
                                                 superSample1(inferFactor=
            false, factor=2)
        annotation (Placement(transformation(extent={{12,26},{24,38}})));
      Modelica_Synchronous.IntegerSignals.SamplerAndHolds.ShiftSample
                                                 shiftSample1(shiftCounter=2,
          resolution=3)
        annotation (Placement(transformation(extent={{-16,-16},{-4,-4}})));
    equation
      connect(integerConstant.y, assignClock1.u) annotation (Line(
          points={{-59,70},{-47.2,70}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(assignClock1.y, hold1.u) annotation (Line(
          points={{-33.4,70},{-21.2,70}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
          points={{-75.4,-90},{-28,-90},{-28,58},{-40,58},{-40,62.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample2.u, integerConstant1.y) annotation (Line(
          points={{-45.2,-10},{-59,-10}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(integerConstant2.y, sample1.u) annotation (Line(
          points={{-59,-50},{-52,-50},{-52,-48},{-45.2,-48}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-75.4,-90},{-28,-90},{-28,-60},{-38,-60},{-38,-55.2}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample2.clock, periodicRealClock.y) annotation (Line(
          points={{-38,-17.2},{-38,-24},{-28,-24},{-28,-90},{-75.4,-90}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(assignClock2.clock, periodicRealClock.y) annotation (Line(
          points={{-40,22.8},{-40,16},{-28,16},{-28,-90},{-75.4,-90}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(integerConstant3.y, assignClock2.u) annotation (Line(
          points={{-59,30},{-47.2,30}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(subSample1.u, assignClock1.y) annotation (Line(
          points={{-21.2,32},{-26,32},{-26,70},{-33.4,70}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(subSample1.y, superSample1.u) annotation (Line(
          points={{-7.4,32},{10.8,32}},
          color={255,127,0},
          smooth=Smooth.None));
      connect(sample2.y, shiftSample1.u) annotation (Line(
          points={{-31.4,-10},{-17.2,-10}},
          color={255,127,0},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics), Icon(graphics));
    end TestIntegerSamplerAndHolds;

    model TestBooleanSamplerAndHolds

      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.AssignClock
                                                 assignClock1
        annotation (Placement(transformation(extent={{-46,64},{-34,76}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-88,-96},{-76,-84}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.Hold
                                          hold1
        annotation (Placement(transformation(extent={{-22,64},{-10,76}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.SampleClocked
                                                   sample2
        annotation (Placement(transformation(extent={{-44,-16},{-32,-4}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.SampleVectorizedAndClocked
                                                                sample1(n=3)
        annotation (Placement(transformation(extent={{-44,-54},{-32,-42}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.AssignClockVectorized
                                                           assignClock2(n=3)
        annotation (Placement(transformation(extent={{-46,24},{-34,36}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.SubSample
                                               subSample1(inferFactor=false,
          factor=2)
        annotation (Placement(transformation(extent={{-20,42},{-8,54}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.SuperSample
                                                 superSample1(inferFactor=
            false, factor=2)
        annotation (Placement(transformation(extent={{12,42},{24,54}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.ShiftSample
                                                 shiftSample1(shiftCounter=2, resolution=3)
        annotation (Placement(transformation(extent={{-16,-16},{-4,-4}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant1[3]
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant2
        annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
      Modelica.Blocks.Sources.BooleanConstant booleanConstant3[3]
        annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
      Modelica_Synchronous.BooleanSignals.SamplerAndHolds.Utilities.ClockedBooleanToBooleanSquareHold
        ClockedSignalToSquare
        annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    equation
      connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
          points={{-75.4,-90},{-28,-90},{-28,58},{-40,58},{-40,62.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(periodicRealClock.y, sample1.clock) annotation (Line(
          points={{-75.4,-90},{-28,-90},{-28,-60},{-38,-60},{-38,-55.2}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(sample2.clock, periodicRealClock.y) annotation (Line(
          points={{-38,-17.2},{-38,-24},{-28,-24},{-28,-90},{-75.4,-90}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(assignClock2.clock, periodicRealClock.y) annotation (Line(
          points={{-40,22.8},{-40,16},{-28,16},{-28,-90},{-75.4,-90}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(booleanConstant.y, assignClock1.u) annotation (Line(
          points={{-59,70},{-47.2,70}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(assignClock2.u, booleanConstant1.y) annotation (Line(
          points={{-47.2,30},{-59,30}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(sample2.u, booleanConstant2.y) annotation (Line(
          points={{-45.2,-10},{-59,-10}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(sample1.u, booleanConstant3.y) annotation (Line(
          points={{-45.2,-48},{-52,-48},{-52,-50},{-59,-50}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(shiftSample1.u, sample2.y) annotation (Line(
          points={{-17.2,-10},{-31.4,-10}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(subSample1.u, assignClock1.y) annotation (Line(
          points={{-21.2,48},{-24,48},{-24,70},{-33.4,70}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(hold1.u, assignClock1.y) annotation (Line(
          points={{-23.2,70},{-33.4,70}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(superSample1.u, subSample1.y) annotation (Line(
          points={{10.8,48},{-7.4,48}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(shiftSample1.y, ClockedSignalToSquare.u) annotation (Line(
          points={{-3.4,-10},{18,-10}},
          color={255,0,255},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics), Icon(graphics));
    end TestBooleanSamplerAndHolds;

    model TestReplaceableSamplerHold
      "Using partial sample and hold blocks to allow redeclaration of blocks to simulated communication blocks"
     extends Modelica.Icons.Example;

      Modelica.Mechanics.Rotational.Components.Inertia load(J=10,
        phi(fixed=true, start=0),
        w(fixed=true, start=0))
        annotation (Placement(transformation(extent={{87,0},{107,20}})));
      Modelica.Mechanics.Rotational.Sensors.SpeedSensor speed       annotation (
         Placement(transformation(
            extent={{-10,-10},{6,6}},
            rotation=-90,
            origin={117,-15})));
      Modelica.Blocks.Sources.Ramp ramp(duration=2)
        annotation (Placement(transformation(extent={{-111,0},{-91,20}})));

      Modelica.Blocks.Math.Feedback feedback
        annotation (Placement(transformation(extent={{-43,0},{-23,20}})));

      Modelica.Mechanics.Rotational.Sources.Torque torque
        annotation (Placement(transformation(extent={{60,0},{80,20}})));

      Modelica_Synchronous.Clocks.PeriodicRealClock periodicClock(period=0.1)
        annotation (Placement(transformation(extent={{-78,-72},{-58,-52}})));
      replaceable
        Modelica_Synchronous.RealSignals.SampleAndHolds.SampleWithADeffects
        sample2 constrainedby Interfaces.PartialRealSISOSampler(
        limited=true,
        quantized=true,
        yMax=10,
        bits=16)
        annotation (Placement(transformation(extent={{-68,4},{-56,16}})));
      replaceable
        Modelica_Synchronous.RealSignals.SampleAndHolds.HoldWithDAeffects
        hold1 constrainedby Modelica_Synchronous.Interfaces.PartialRealSISOHold(
        computationalDelay=true,
        resolution=10,
        shiftCounter=2,
        limited=true,
        quantized=true,
        yMax=9.5,
        yMin=-9.5,
        bits=16)
        annotation (Placement(transformation(extent={{26,4},{38,16}})));
      replaceable
        Modelica_Synchronous.RealSignals.SampleAndHolds.SampleWithADeffects
        sample1 constrainedby Interfaces.PartialRealSISOSampler(noisy=
            true, noise(noiseMax=0.01))
        annotation (Placement(transformation(extent={{38,-36},{26,-24}})));
      Modelica_Synchronous.RealSignals.NonPeriodic.PI
                 PI(
        x(fixed=true),
        T=0.1,
        k=110)
        annotation (Placement(transformation(extent={{-14,0},{6,20}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.AssignClock
                                              assignClock1
        annotation (Placement(transformation(extent={{8,-36},{-4,-24}})));
    equation
      connect(speed.flange, load.flange_b)       annotation (Line(
          points={{115,-5},{115,10},{107,10}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(torque.flange, load.flange_a) annotation (Line(
          points={{80,10},{87,10}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(ramp.y, sample2.u) annotation (Line(
          points={{-90,10},{-69.2,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample2.y, feedback.u1) annotation (Line(
          points={{-55.4,10},{-41,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(hold1.y, torque.tau) annotation (Line(
          points={{38.6,10},{58,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(speed.w, sample1.u) annotation (Line(
          points={{115,-21.8},{115,-30},{39.2,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(feedback.y, PI.u) annotation (Line(
          points={{-24,10},{-16,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(PI.y, hold1.u) annotation (Line(
          points={{7,10},{24.8,10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, assignClock1.u) annotation (Line(
          points={{25.4,-30},{9.2,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(assignClock1.y, feedback.u2) annotation (Line(
          points={{-4.6,-30},{-33,-30},{-33,2}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicClock.y, assignClock1.clock) annotation (Line(
          points={{-57,-62},{2,-62},{2,-37.2}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-140,-100},
                {140,100}},
            grid={2,2}), graphics={
            Text(
              extent={{-41,39},{9,33}},
              lineColor={255,0,0},
              textString="feedback controller"),
            Text(
              extent={{54,39},{104,33}},
              lineColor={255,0,0},
              textString="plant"),
            Rectangle(extent={{-120,40},{-80,-20}}, lineColor={255,0,0}),
            Text(
              extent={{-125,39},{-77,33}},
              lineColor={255,0,0},
              textString="reference"),
            Rectangle(extent={{-46,40},{14,-48}}, lineColor={255,0,0}),
            Rectangle(extent={{50,40},{132,-48}}, lineColor={255,0,0})}),
                                          DymolaStoredErrors,
        Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={2,2})),
        Documentation(info="<HTML>
</HTML>"),
        experiment(
          StopTime=5,
          fixedstepsize=0.001,
          Algorithm="Dassl"),
        experimentSetupOutput);
    end TestReplaceableSamplerHold;

    model TestSimulatedADC
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-58,22},{-46,34}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleWithADeffects
                                                      sample1
        annotation (Placement(transformation(extent={{-44,44},{-32,56}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.AssignClock
                                              assignClock1
        annotation (Placement(transformation(extent={{-16,44},{-4,56}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.HoldWithDAeffects
                                                    hold1(
        computationalDelay=true,
        shiftCounter=1,
        resolution=2,
        limited=true,
        quantized=true)
        annotation (Placement(transformation(extent={{10,44},{22,56}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-45.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, assignClock1.u) annotation (Line(
          points={{-31.4,50},{-17.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
          points={{-45.4,28},{-10,28},{-10,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(assignClock1.y, hold1.u) annotation (Line(
          points={{-3.4,50},{8.8,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics));
    end TestSimulatedADC;

    model TestCommunicationDelay
      Modelica.Blocks.Sources.Sine sine(freqHz=2,
        offset=0.1,
        startTime=0)
        annotation (Placement(transformation(extent={{-92,40},{-72,60}})));
      Clocks.PeriodicRealClock periodicRealClock(period=0.1)
        annotation (Placement(transformation(extent={{-66,18},{-54,30}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleWithADeffects
                                                      sample1
        annotation (Placement(transformation(extent={{-58,44},{-46,56}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.AssignClock
                                              assignClock1
        annotation (Placement(transformation(extent={{-30,44},{-18,56}})));
      Modelica_Synchronous.RealSignals.NonPeriodic.FractionalDelay
                                                       fixedDelay(shift=3,
          resolution=2)
        annotation (Placement(transformation(extent={{-6,40},{14,60}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-71,50},{-59.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, assignClock1.u) annotation (Line(
          points={{-45.4,50},{-31.2,50}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicRealClock.y, assignClock1.clock) annotation (Line(
          points={{-53.4,24},{-24,24},{-24,42.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      connect(assignClock1.y, fixedDelay.u) annotation (Line(
          points={{-17.4,50},{-8,50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                          graphics));
    end TestCommunicationDelay;

    model TestEventClockWithIntegrator
     extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;
      Clocks.EventClock eventClock(useSolver=true, solverMethod="ExplicitEuler")
        annotation (Placement(transformation(extent={{-36,23},{-24,37}})));
      Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=60, period=0.1)
        annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
      Modelica.Blocks.Continuous.FirstOrder firstOrder(T=0.1)
        annotation (Placement(transformation(extent={{20,60},{40,80}})));
      Modelica.Blocks.Sources.Sine sine(freqHz=2)
        annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-6,64},{6,76}})));
    equation
      connect(booleanPulse.y, eventClock.u) annotation (Line(
          points={{-59,30},{-37.2,30}},
          color={255,0,255},
          smooth=Smooth.None));
      connect(sine.y, sample1.u) annotation (Line(
          points={{-19,70},{-7.2,70}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, firstOrder.u) annotation (Line(
          points={{6.6,70},{18,70}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(eventClock.y, sample1.clock) annotation (Line(
          points={{-23.4,30},{0,30},{0,62.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics));
    end TestEventClockWithIntegrator;

    model TestExactClockWithIntegrator
    extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;
      Modelica.Blocks.Continuous.FirstOrder firstOrder(T=0.1)
        annotation (Placement(transformation(extent={{20,60},{40,80}})));
      Modelica.Blocks.Sources.Sine sine(freqHz=2)
        annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
      Modelica_Synchronous.RealSignals.SampleAndHolds.SampleClocked
                                                sample1
        annotation (Placement(transformation(extent={{-6,64},{6,76}})));
      Clocks.PeriodicExactClock periodicExactClock(
        factor=2,
        useSolver=true,
        solverMethod="ExplicitEuler",
        resolution=Modelica_Synchronous.Types.Resolution.us)
        annotation (Placement(transformation(extent={{-34,26},{-22,38}})));
    equation
      connect(sine.y, sample1.u) annotation (Line(
          points={{-19,70},{-7.2,70}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sample1.y, firstOrder.u) annotation (Line(
          points={{6.6,70},{18,70}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(periodicExactClock.y, sample1.clock) annotation (Line(
          points={{-21.4,32},{0,32},{0,62.8}},
          color={175,175,175},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None));
      annotation (
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics),
        experiment(StopTime=0.0001),
        __Dymola_experimentSetupOutput);
    end TestExactClockWithIntegrator;

    model TestSuperSampleClock
      extends Modelica_Synchronous.WorkInProgress.Icons.OperatesOnlyPartially;
      parameter Integer factor=2 annotation(Evaluate=true);
      Clock c1;
      Clock c2;
    equation
      c1 = superSample(Clock(factor), 1000);
      c2 = superSample(Clock(factor), 1000*1000);
    end TestSuperSampleClock;

  end Tests;

  block Interpolator
    "Super-sample the clocked Real input signal and provide it linearly interpolated and optionally filterd as clocked output signal"
    parameter Boolean inferFactor=true
      "= true, if super-sampling factor is inferred"  annotation(Evaluate=true, choices(__Dymola_checkBox=true));
    parameter Integer factor(min=1)=1
      "Super-sampling factor >= 1 (if inferFactor=false)"
                                                  annotation(Evaluate=true, Dialog(enable=not inferFactor));
    parameter Boolean movingAverageFilter = true
      "= true, linearly interpolated signal is filtered by moving average filter (current restriction: inferFactor and movingAverageFilter cannot be both true)"
      annotation(choices(__Dymola_checkBox=true));

    Modelica.Blocks.Interfaces.RealInput u
      "Connector of clocked, Real input signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0)));
    Modelica.Blocks.Interfaces.RealOutput y
      "Connector of clocked, Real output signal (clock of y is faster als clock of u)"
      annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));
    Modelica_Synchronous.RealSignals.SampleAndHolds.SuperSampleInterpolated  superSampleIpo(final
        inferFactor=inferFactor, final factor=factor)
      annotation (Placement(transformation(extent={{-76,-6},{-64,6}})));
    Modelica_Synchronous.RealSignals.Periodic.MovingAverage
                           movingAverage(final n=factor) if movingAverageFilter
      annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  protected
    Modelica.Blocks.Interfaces.RealOutput y_aux if not movingAverageFilter
      "Dummy port, if no filtering desired"
      annotation (Placement(transformation(extent={{8,22},{28,42}})));
  equation
    assert(not (inferFactor and movingAverageFilter), "There is the current restriction that interFactor and movingAverageFilter\n"+
                                                      "cannot be both true");
    connect(u, superSampleIpo.u)  annotation (Line(
        points={{-120,0},{-77.2,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(superSampleIpo.y, movingAverage.u)  annotation (Line(
        points={{-63.4,0},{2,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(movingAverage.y, y) annotation (Line(
        points={{25,0},{110,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(superSampleIpo.y, y_aux)  annotation (Line(
        points={{-63.4,0},{-16,0},{-16,32},{18,32}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(y_aux, y) annotation (Line(
        points={{18,32},{40,32},{40,0},{110,0}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={2,2},
          initialScale=0.06),
          graphics={
          Rectangle(
            extent={{-88,86},{90,-72}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Line(
            points={{-100,0},{-80,0},{-80,-60},{0,-60},{0,80},{80,80},{80,0.078125},
                {100,0}},
            color={215,215,215},
            smooth=Smooth.None,
            pattern=LinePattern.Dot),
          Text(
            extent={{-200,173},{200,108}},
            lineColor={0,0,255},
            textString="%name"), Line(points={{-100,0},{-40,-60},{-40,-60},{-40,-60},
                {0,12},{46,82},{46,82},{80,42},{100,0}},
                                   color={0,0,127},
            pattern=LinePattern.Dot),
          Ellipse(
            extent={{-55,-43},{-25,-73}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-83,-57},{-77,-63}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-3,83},{3,77}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{65,56},{95,26}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-16,26},{14,-4}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{32,96},{62,66}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{77,3},{83,-3}},
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid),
          Text(visible=not inferFactor,
            extent={{-200,-75},{200,-140}},
            lineColor={0,0,0},
            textString="%factor"),
          Polygon(
            points={{25,0},{5,20},{5,10},{-25,10},{-25,-10},{5,-10},{5,-20},
                {25,0}},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid,
            lineColor={95,95,95},
            origin={-57,24},
            rotation=90)}),        Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}),
                                           graphics));
  end Interpolator;
end WorkInProgress;
