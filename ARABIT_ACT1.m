classdef ArabitPlate1 < matlab.apps.AppBase
    properties (Access = public)
        UIFigure matlab.ui.Figure
        UIAxes matlab.ui.control.UIAxes
        BottomPanel matlab.ui.container.Panel
        ImpulseButton matlab.ui.control.Button
        UnitStepButton matlab.ui.control.Button
        RampButton matlab.ui.control.Button
        SineButton matlab.ui.control.Button
        CosineButton matlab.ui.control.Button
        ClearButton matlab.ui.control.Button
        AmplitudeEditField matlab.ui.control.NumericEditField
        AmplitudeLabel matlab.ui.control.Label
        TimeScalingEditField matlab.ui.control.NumericEditField
        TimeScalingLabel matlab.ui.control.Label
        TimeShiftEditField matlab.ui.control.NumericEditField
        TimeShiftLabel matlab.ui.control.Label
    end

    methods (Access = private)
        function plotSignal(app, signal, titleStr)
            t = -10:0.5:10;
            stem(app.UIAxes, t, signal, 'filled');
            hold(app.UIAxes, 'on');
            plot(app.UIAxes, [-10 10], [0 0], 'k-', 'LineWidth', 0.5);
            hold(app.UIAxes, 'off');
            xlabel(app.UIAxes, 'Time (n)');
            ylabel(app.UIAxes, 'Amplitude');
            title(app.UIAxes, titleStr);
            grid(app.UIAxes, 'on');
            xlim(app.UIAxes, [-10 10]);
            yMin = min(signal);
            yMax = max(signal);
            yRange = yMax - yMin;
            if yRange < 0.1
                yRange = 2;
            end
            ylim(app.UIAxes, [yMin - 0.3*yRange, yMax + 0.3*yRange]);
            app.UIAxes.YAxisLocation = 'origin';
        end

        function ImpulseButtonPushed(app, ~)
            A = app.AmplitudeEditField.Value;
            a = app.TimeScalingEditField.Value;
            t0 = app.TimeShiftEditField.Value;
            t = -10:0.5:10;
            signal = A * (abs(a * t - t0) < 0.5);
            plotSignal(app, signal, sprintf('Impulse: %.1fδ(%.1fn - %.1f)', A, a, t0));
        end

        function UnitStepButtonPushed(app, ~)
            A = app.AmplitudeEditField.Value;
            a = app.TimeScalingEditField.Value;
            t0 = app.TimeShiftEditField.Value;
            t = -10:0.5:10;
            signal = A * (a * t - t0 >= 0);
            plotSignal(app, signal, sprintf('Unit Step: %.1fu(%.1fn - %.1f)', A, a, t0));
        end

        function RampButtonPushed(app, ~)
            A = app.AmplitudeEditField.Value;
            a = app.TimeScalingEditField.Value;
            t0 = app.TimeShiftEditField.Value;
            t = -10:0.5:10;
            t_scaled = a * t - t0;
            signal = A * t_scaled .* (t_scaled >= 0);
            plotSignal(app, signal, sprintf('Ramp: %.1fn×u(%.1fn - %.1f)', A, a, t0));
        end

        function SineButtonPushed(app, ~)
            A = app.AmplitudeEditField.Value;
            a = app.TimeScalingEditField.Value;
            t0 = app.TimeShiftEditField.Value;
            t = -10:0.5:10;
            signal = A * sin(a * t - t0);
            plotSignal(app, signal, sprintf('Sine: %.1fsin(%.1fn - %.1f)', A, a, t0));
        end

        function CosineButtonPushed(app, ~)
            A = app.AmplitudeEditField.Value;
            a = app.TimeScalingEditField.Value;
            t0 = app.TimeShiftEditField.Value;
            t = -10:0.5:10;
            signal = A * cos(a * t - t0);
            plotSignal(app, signal, sprintf('Cosine: %.1fcos(%.1fn - %.1f)', A, a, t0));
        end

        function ClearButtonPushed(app, ~)
            cla(app.UIAxes);
            title(app.UIAxes, 'Signal Plot');
            xlabel(app.UIAxes, 'Time (n)');
            ylabel(app.UIAxes, 'Amplitude');
            grid(app.UIAxes, 'on');
            xlim(app.UIAxes, [-10 10]);
            app.UIAxes.YAxisLocation = 'origin';
        end
    end

    methods (Access = private)
        function createComponents(app)
            color_DeepBlue_RGB = [0.016 0.529 0.851];
            color_LightBlue_RGB = [0.016 0.616 0.851];
            color_VeryLightBlue_RGB = [0.769 0.933 0.949];
            color_Orange_RGB = [0.949 0.671 0.427];
            color_Beige_RGB = [0.949 0.839 0.741];

            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 900 700];
            app.UIFigure.Name = 'Arabit Plate#1';
            app.UIFigure.Color = color_VeryLightBlue_RGB;

            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [50 280 800 400];
            title(app.UIAxes, 'Plate #1 (Plotter): Jule Cyrus Arabit');
            xlabel(app.UIAxes, 'Time (n)');
            ylabel(app.UIAxes, 'Amplitude');
            grid(app.UIAxes, 'on');
            xlim(app.UIAxes, [-10 10]);
            app.UIAxes.YAxisLocation = 'origin';
            app.UIAxes.BackgroundColor = 'white';

            dockHeight = 250;
            app.BottomPanel = uipanel(app.UIFigure);
            app.BottomPanel.Position = [0 0 900 dockHeight];
            app.BottomPanel.BackgroundColor = color_DeepBlue_RGB;
            app.BottomPanel.BorderType = 'none';

            row1_y = 150;
            app.AmplitudeLabel = uilabel(app.BottomPanel);
            app.AmplitudeLabel.Position = [50 row1_y 100 22];
            app.AmplitudeLabel.Text = 'Amplitude (A):';
            app.AmplitudeLabel.FontColor = 'white';
            
            app.AmplitudeEditField = uieditfield(app.BottomPanel, 'numeric');
            app.AmplitudeEditField.Position = [140 row1_y 80 22];
            app.AmplitudeEditField.Value = 1;

            app.TimeScalingLabel = uilabel(app.BottomPanel);
            app.TimeScalingLabel.Position = [280 row1_y 110 22];
            app.TimeScalingLabel.Text = 'Time Scaling (a):';
            app.TimeScalingLabel.FontColor = 'white';
            
            app.TimeScalingEditField = uieditfield(app.BottomPanel, 'numeric');
            app.TimeScalingEditField.Position = [400 row1_y 80 22];
            app.TimeScalingEditField.Value = 1;

            app.TimeShiftLabel = uilabel(app.BottomPanel);
            app.TimeShiftLabel.Position = [520 row1_y 100 22];
            app.TimeShiftLabel.Text = 'Time Shift (t0):';
            app.TimeShiftLabel.FontColor = 'white';
            
            app.TimeShiftEditField = uieditfield(app.BottomPanel, 'numeric');
            app.TimeShiftEditField.Position = [630 row1_y 80 22];
            app.TimeShiftEditField.Value = 0;

            row2_y = 80;
            gap = 10;
            btnWidth = 120;
            startX = 50;

            app.ImpulseButton = uibutton(app.BottomPanel, 'push');
            app.ImpulseButton.ButtonPushedFcn = createCallbackFcn(app, @ImpulseButtonPushed, true);
            app.ImpulseButton.Position = [startX+0*(btnWidth+gap) row2_y btnWidth 40];
            app.ImpulseButton.Text = 'Impulse δ(n)';
            app.ImpulseButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.UnitStepButton = uibutton(app.BottomPanel, 'push');
            app.UnitStepButton.ButtonPushedFcn = createCallbackFcn(app, @UnitStepButtonPushed, true);
            app.UnitStepButton.Position = [startX+1*(btnWidth+gap) row2_y btnWidth 40];
            app.UnitStepButton.Text = 'Unit Step u(n)';
            app.UnitStepButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.RampButton = uibutton(app.BottomPanel, 'push');
            app.RampButton.ButtonPushedFcn = createCallbackFcn(app, @RampButtonPushed, true);
            app.RampButton.Position = [startX+2*(btnWidth+gap) row2_y btnWidth 40];
            app.RampButton.Text = 'Ramp r(n)';
            app.RampButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.SineButton = uibutton(app.BottomPanel, 'push');
            app.SineButton.ButtonPushedFcn = createCallbackFcn(app, @SineButtonPushed, true);
            app.SineButton.Position = [startX+3*(btnWidth+gap) row2_y btnWidth 40];
            app.SineButton.Text = 'Sine sin(n)';
            app.SineButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.CosineButton = uibutton(app.BottomPanel, 'push');
            app.CosineButton.ButtonPushedFcn = createCallbackFcn(app, @CosineButtonPushed, true);
            app.CosineButton.Position = [startX+4*(btnWidth+gap) row2_y btnWidth 40];
            app.CosineButton.Text = 'Cosine cos(n)';
            app.CosineButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.ClearButton = uibutton(app.BottomPanel, 'push');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.Position = [startX+5*(btnWidth+gap) row2_y btnWidth 40];
            app.ClearButton.Text = 'Clear Plot';
            app.ClearButton.BackgroundColor = color_Beige_RGB;

            footerLbl = uilabel(app.BottomPanel);
            footerLbl.Position = [10 10 200 22];
            footerLbl.Text = 'Jule Cyrus Arabit - Plate #1';
            footerLbl.FontColor = color_VeryLightBlue_RGB;
            footerLbl.FontSize = 10;

            app.UIFigure.Visible = 'on';
        end
    end

    methods (Access = public)
        function app = ArabitPlate1
            createComponents(app)
            registerApp(app, app.UIFigure)
            if nargout == 0
                clear app
            end
        end

        function delete(app)
            delete(app.UIFigure)
        end
    end
end
