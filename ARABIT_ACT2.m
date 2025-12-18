classdef ArabitPlate2 < matlab.apps.AppBase
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
        ConvolveButton matlab.ui.control.Button
        AmplitudeEditField matlab.ui.control.NumericEditField
        AmplitudeLabel matlab.ui.control.Label
        TimeScalingEditField matlab.ui.control.NumericEditField
        TimeScalingLabel matlab.ui.control.Label
        TimeShiftEditField matlab.ui.control.NumericEditField
        TimeShiftLabel matlab.ui.control.Label
        Signal1EditField matlab.ui.control.EditField
        Signal1Label matlab.ui.control.Label
        Signal2EditField matlab.ui.control.EditField
        Signal2Label matlab.ui.control.Label
        TargetSignalButtonGroup matlab.ui.container.ButtonGroup
        Signal1RadioButton matlab.ui.control.RadioButton
        Signal2RadioButton matlab.ui.control.RadioButton
        signal1_data
        signal1_name
        signal2_data
        signal2_name
        t = -10:1:10
    end

    methods (Access = private)
        function createComponents(app)
            color_DeepBlue_RGB = [0.016 0.529 0.851];
            color_LightBlue_RGB = [0.016 0.616 0.851];
            color_VeryLightBlue_RGB = [0.769 0.933 0.949];
            color_Orange_RGB = [0.949 0.671 0.427];
            color_Beige_RGB = [0.949 0.839 0.741];
            
            app.UIFigure = uifigure('Visible', 'off', 'Position', [100 100 900 700], 'Name', 'Arabit Plate#2');
            app.UIFigure.Color = color_VeryLightBlue_RGB;
            
            app.UIAxes = uiaxes(app.UIFigure, 'Position', [50 280 800 400]);
            title(app.UIAxes, 'Plate #2 (Convolution): Jule Cyrus Arabit');
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

            row1_y = 200;
            app.Signal1Label = uilabel(app.BottomPanel, 'Position', [50 row1_y 60 22], 'Text', 'Signal 1:', 'FontColor', 'white');
            app.Signal1EditField = uieditfield(app.BottomPanel, 'text', 'Position', [110 row1_y 200 22]);
            app.Signal1EditField.Editable = 'off';
            
            app.Signal2Label = uilabel(app.BottomPanel, 'Position', [340 row1_y 60 22], 'Text', 'Signal 2:', 'FontColor', 'white');
            app.Signal2EditField = uieditfield(app.BottomPanel, 'text', 'Position', [400 row1_y 200 22]);
            app.Signal2EditField.Editable = 'off';

            app.TargetSignalButtonGroup = uibuttongroup(app.BottomPanel, 'Title', 'Edit Target', 'Position', [650 row1_y-10 200 50]);
            app.TargetSignalButtonGroup.BackgroundColor = color_LightBlue_RGB;
            app.TargetSignalButtonGroup.ForegroundColor = 'white';
            
            app.Signal1RadioButton = uiradiobutton(app.TargetSignalButtonGroup, 'Text', 'Signal 1', 'Position', [10 5 80 20], 'FontColor', 'white', 'Value', true);
            app.Signal2RadioButton = uiradiobutton(app.TargetSignalButtonGroup, 'Text', 'Signal 2', 'Position', [100 5 80 20], 'FontColor', 'white');

            row2_y = 150;
            app.AmplitudeLabel = uilabel(app.BottomPanel, 'Position', [50 row2_y 100 22], 'Text', 'Amplitude (A):', 'FontColor', 'white');
            app.AmplitudeEditField = uieditfield(app.BottomPanel, 'numeric', 'Position', [140 row2_y 60 22], 'Value', 1);
            
            app.TimeScalingLabel = uilabel(app.BottomPanel, 'Position', [250 row2_y 110 22], 'Text', 'Time Scaling (a):', 'FontColor', 'white');
            app.TimeScalingEditField = uieditfield(app.BottomPanel, 'numeric', 'Position', [350 row2_y 60 22], 'Value', 1);
            
            app.TimeShiftLabel = uilabel(app.BottomPanel, 'Position', [450 row2_y 100 22], 'Text', 'Time Shift (t0):', 'FontColor', 'white');
            app.TimeShiftEditField = uieditfield(app.BottomPanel, 'numeric', 'Position', [550 row2_y 60 22], 'Value', 0);

            row3_y = 90;
            gap = 10;
            btnWidth = 100;
            startX = 50;
            
            app.ImpulseButton = uibutton(app.BottomPanel, 'push', 'Position', [startX+0*(btnWidth+gap) row3_y btnWidth 40], 'Text', 'Impulse δ(n)');
            app.ImpulseButton.ButtonPushedFcn = createCallbackFcn(app, @ImpulseButtonPushed, true);
            app.ImpulseButton.BackgroundColor = color_VeryLightBlue_RGB; 

            app.UnitStepButton = uibutton(app.BottomPanel, 'push', 'Position', [startX+1*(btnWidth+gap) row3_y btnWidth 40], 'Text', 'Unit Step u(n)');
            app.UnitStepButton.ButtonPushedFcn = createCallbackFcn(app, @UnitStepButtonPushed, true);
            app.UnitStepButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.RampButton = uibutton(app.BottomPanel, 'push', 'Position', [startX+2*(btnWidth+gap) row3_y btnWidth 40], 'Text', 'Ramp r(n)');
            app.RampButton.ButtonPushedFcn = createCallbackFcn(app, @RampButtonPushed, true);
            app.RampButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.SineButton = uibutton(app.BottomPanel, 'push', 'Position', [startX+3*(btnWidth+gap) row3_y btnWidth 40], 'Text', 'Sine sin(n)');
            app.SineButton.ButtonPushedFcn = createCallbackFcn(app, @SineButtonPushed, true);
            app.SineButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.CosineButton = uibutton(app.BottomPanel, 'push', 'Position', [startX+4*(btnWidth+gap) row3_y btnWidth 40], 'Text', 'Cosine cos(n)');
            app.CosineButton.ButtonPushedFcn = createCallbackFcn(app, @CosineButtonPushed, true);
            app.CosineButton.BackgroundColor = color_VeryLightBlue_RGB;

            app.ClearButton = uibutton(app.BottomPanel, 'push', 'Position', [startX+5*(btnWidth+gap) row3_y btnWidth 40], 'Text', 'Clear Plot');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.BackgroundColor = color_Beige_RGB;

            row4_y = 20;
            app.ConvolveButton = uibutton(app.BottomPanel, 'push');
            app.ConvolveButton.Position = [250 20 400 50];
            app.ConvolveButton.Text = 'CONVOLVE SIGNALS';
            app.ConvolveButton.ButtonPushedFcn = createCallbackFcn(app, @ConvolveButtonPushed, true);
            app.ConvolveButton.BackgroundColor = color_Orange_RGB;
            app.ConvolveButton.FontColor = 'white';
            app.ConvolveButton.FontSize = 16;
            app.ConvolveButton.FontWeight = 'bold';

            footerLbl = uilabel(app.BottomPanel);
            footerLbl.Position = [10 5 200 20];
            footerLbl.Text = 'Jule Cyrus Arabit - Plate #2';
            footerLbl.FontColor = color_VeryLightBlue_RGB;
            footerLbl.FontSize = 10;

            app.UIFigure.Visible = 'on';
        end

        function storeSignal(app, signal, signalName, targetField)
            if targetField == 1
                if ~isempty(app.signal1_data)
                    choice = uiconfirm(app.UIFigure, 'Signal 1 already exists. What would you like to do?', 'Signal Exists', 'Options', {'Replace', 'Add', 'Subtract', 'Cancel'}, 'DefaultOption', 1);
                    if strcmp(choice, 'Cancel')
                        return;
                    elseif strcmp(choice, 'Add')
                        signal = app.signal1_data + signal;
                        signalName = ['(' app.signal1_name ') + (' signalName ')'];
                    elseif strcmp(choice, 'Subtract')
                        signal = app.signal1_data - signal;
                        signalName = ['(' app.signal1_name ') - (' signalName ')'];
                    end
                end
                app.signal1_data = signal;
                app.signal1_name = signalName;
                app.Signal1EditField.Value = signalName;
            else
                if ~isempty(app.signal2_data)
                    choice = uiconfirm(app.UIFigure, 'Signal 2 already exists. What would you like to do?', 'Signal Exists', 'Options', {'Replace', 'Add', 'Subtract', 'Cancel'}, 'DefaultOption', 1);
                    if strcmp(choice, 'Cancel')
                        return;
                    elseif strcmp(choice, 'Add')
                        signal = app.signal2_data + signal;
                        signalName = ['(' app.signal2_name ') + (' signalName ')'];
                    elseif strcmp(choice, 'Subtract')
                        signal = app.signal2_data - signal;
                        signalName = ['(' app.signal2_name ') - (' signalName ')'];
                    end
                end
                app.signal2_data = signal;
                app.signal2_name = signalName;
                app.Signal2EditField.Value = signalName;
            end
            updateSignalPlot(app);
        end
        function updateSignalPlot(app)
            cla(app.UIAxes);
            hold(app.UIAxes, 'on');
            t = -10:1:10;
            hasSignals = false;
            if ~isempty(app.signal1_data)
                stem(app.UIAxes, t, app.signal1_data, 'b', 'filled', 'DisplayName', ['Signal 1: ' app.signal1_name]);
                hasSignals = true;
            end
            if ~isempty(app.signal2_data)
                stem(app.UIAxes, t, app.signal2_data, 'r', 'filled', 'DisplayName', ['Signal 2: ' app.signal2_name]);
                hasSignals = true;
            end
            plot(app.UIAxes, [-10 10], [0 0], 'k-', 'LineWidth', 0.5, 'HandleVisibility', 'off');
            hold(app.UIAxes, 'off');
            xlabel(app.UIAxes, 'Time (n)');
            ylabel(app.UIAxes, 'Amplitude');
            if hasSignals
                title(app.UIAxes, 'Current Signals');
                legend(app.UIAxes, 'Location', 'northeast');
                allValues = [app.signal1_data app.signal2_data];
                yMin = min(allValues);
                yMax = max(allValues);
                yRange = max(yMax - yMin, 2);
                ylim(app.UIAxes, [yMin - 0.3*yRange, yMax + 0.3*yRange]);
            else
                title(app.UIAxes, 'Plate #2 (Convolution): Jule Cyrus Arabit');
            end
            grid(app.UIAxes, 'on');
            xlim(app.UIAxes, [-10 10]);
            app.UIAxes.YAxisLocation = 'origin';
        end
        function generateSignal(app, type)
            A = app.AmplitudeEditField.Value;
            a = app.TimeScalingEditField.Value;
            t0 = app.TimeShiftEditField.Value;
            t = -10:1:10;
            t_scaled = a * t - t0;
            switch type
                case 'impulse'
                    signal = A * (abs(t_scaled) < 0.001);
                    signalName = sprintf('%.1fδ(%.1fn-%.1f)', A, a, t0);
                case 'step'
                    signal = A * (t_scaled >= 0);
                    signalName = sprintf('%.1fu(%.1fn-%.1f)', A, a, t0);
                case 'ramp'
                    signal = A * t_scaled .* (t_scaled >= 0);
                    signalName = sprintf('%.1fn×u(%.1fn-%.1f)', A, a, t0);
                case 'sine'
                    signal = A * sin(t_scaled);
                    signalName = sprintf('%.1fsin(%.1fn-%.1f)', A, a, t0);
                case 'cosine'
                    signal = A * cos(t_scaled);
                    signalName = sprintf('%.1fcos(%.1fn-%.1f)', A, a, t0);
            end
            targetField = app.Signal1RadioButton.Value;
            storeSignal(app, signal, signalName, targetField);
        end
        function ImpulseButtonPushed(app, ~)
            generateSignal(app, 'impulse');
        end
        function UnitStepButtonPushed(app, ~)
            generateSignal(app, 'step');
        end
        function RampButtonPushed(app, ~)
            generateSignal(app, 'ramp');
        end
        function SineButtonPushed(app, ~)
            generateSignal(app, 'sine');
        end
        function CosineButtonPushed(app, ~)
            generateSignal(app, 'cosine');
        end
        function ClearButtonPushed(app, ~)
            app.signal1_data = [];
            app.signal1_name = '';
            app.signal2_data = [];
            app.signal2_name = '';
            app.Signal1EditField.Value = '';
            app.Signal2EditField.Value = '';
            updateSignalPlot(app);
        end
        function ConvolveButtonPushed(app, ~)
            if isempty(app.signal1_data) || isempty(app.signal2_data)
                uialert(app.UIFigure, 'Please select two signals before convolving!', 'Missing Signals');
                return;
            end
            x_nonzero = find(app.signal1_data ~= 0);
            h_nonzero = find(app.signal2_data ~= 0);
            if isempty(x_nonzero) || isempty(h_nonzero)
                uialert(app.UIFigure, 'One or both signals are zero everywhere!', 'Invalid Signals');
                return;
            end
            t = -10:1:10;
            conv_start = t(min(x_nonzero)) + t(min(h_nonzero));
            conv_end = t(max(x_nonzero)) + t(max(h_nonzero));
            if conv_start < -10 || conv_end > 10
                result = showRangeDialog(app, conv_start, conv_end);
                if isempty(result)
                    return;
                end
                app.t = result;
            else
                app.t = -10:1:10;
            end
            animateConvolution(app);
        end
        function t_result = showRangeDialog(app, conv_start, conv_end)
            t_result = [];
            dlg = uifigure('Name', 'Signal Range Warning', 'Position', [100 100 450 280]);
            msg = uilabel(dlg, 'Position', [20 200 410 70], 'WordWrap', 'on');
            msg.Text = sprintf('Convolution result will span: [%.1f, %.1f]\nThis exceeds the display range [-10, 10].\nSet custom range for input signals during animation:', conv_start, conv_end);
            uilabel(dlg, 'Position', [20 160 150 22], 'Text', 'Input signals range:');
            minField = uieditfield(dlg, 'numeric', 'Position', [170 160 80 22], 'Value', -10);
            uilabel(dlg, 'Position', [260 160 30 22], 'Text', 'to:');
            maxField = uieditfield(dlg, 'numeric', 'Position', [300 160 80 22], 'Value', 10);
            noteLabel = uilabel(dlg, 'Position', [20 120 410 30], 'FontAngle', 'italic', 'FontColor', [0.5 0.5 0.5]);
            noteLabel.Text = '(Convolution output will automatically adjust to full range)';
            continueBtn = uibutton(dlg, 'Position', [130 60 90 30], 'Text', 'Continue', 'ButtonPushedFcn', @(~,~) doContinue());
            cancelBtn = uibutton(dlg, 'Position', [240 60 90 30], 'Text', 'Cancel', 'ButtonPushedFcn', @(~,~) doCancel());
            uiwait(dlg);
            if isvalid(dlg) && ~isempty(dlg.UserData)
                t_result = dlg.UserData;
            end
            if isvalid(dlg), delete(dlg); end
            function doContinue()
                dlg.UserData = linspace(minField.Value, maxField.Value, round(maxField.Value - minField.Value) + 1);
                uiresume(dlg);
            end
            function doCancel()
                dlg.UserData = [];
                uiresume(dlg);
            end
        end
        function animateConvolution(app)
            if isempty(app.t)
                t = -10:1:10;
            else
                t = app.t;
            end
            if length(t) < 2
                uialert(app.UIFigure, 'Time vector too short!', 'Error');
                return;
            end
            dt = max(t(2) - t(1), 1);
            t_orig = -10:1:10;
            x = interp1(t_orig, app.signal1_data, t, 'nearest', 0);
            h = interp1(t_orig, app.signal2_data, t, 'nearest', 0);
            N = length(t);
            conv_result = conv(x, h) * dt;
            conv_t = linspace(2*t(1), 2*t(end), length(conv_result));
            cla(app.UIAxes);
            hold(app.UIAxes, 'on');
            stem(app.UIAxes, t, x, 'b', 'filled', 'DisplayName', ['Signal 1: ' app.signal1_name]);
            stem(app.UIAxes, t, h, 'r', 'filled', 'DisplayName', ['Signal 2: ' app.signal2_name]);
            plot(app.UIAxes, [t(1) t(end)], [0 0], 'k-', 'LineWidth', 0.5, 'HandleVisibility', 'off');
            hold(app.UIAxes, 'off');
            xlabel(app.UIAxes, 'Time (n)');
            ylabel(app.UIAxes, 'Amplitude');
            title(app.UIAxes, 'Input Signals');
            legend(app.UIAxes, 'Location', 'northeast');
            grid(app.UIAxes, 'on');
            allValues = [x, h];
            yRange = max(max(allValues) - min(allValues), 2);
            ylim(app.UIAxes, [min(allValues) - 0.3*yRange, max(allValues) + 0.3*yRange]);
            app.UIAxes.YAxisLocation = 'origin';
            pause(1.5);
            x_nonzero = find(x ~= 0);
            h_nonzero = find(h ~= 0);
            conv_nonzero = find(abs(conv_result) > 1e-10);
            if ~isempty(conv_nonzero)
                startIdx = max(1, min(conv_nonzero) - 4);
                endIdx = min(length(conv_result), max(conv_nonzero) + 4);
            else
                startIdx = 1;
                endIdx = length(conv_result);
            end
            h_range = t(max(h_nonzero)) - t(min(h_nonzero));
            x_range = t(max(x_nonzero)) - t(min(x_nonzero));
            pad = max(h_range, x_range);
            t_extended = t(1)-pad:dt:t(end)+pad;
            x_extended = interp1(t, x, t_extended, 'nearest', 0);
            h_extended = interp1(t, h, t_extended, 'nearest', 0);
            x_min_global = min([t_extended(1), conv_t(startIdx)]);
            x_max_global = max([t_extended(end), conv_t(endIdx)]);
            allPossibleValues = [x, h, conv_result(startIdx:endIdx)];
            yRange_global = max(max(allPossibleValues) - min(allPossibleValues), 2);
            ylim_global = [min(allPossibleValues) - 0.3*yRange_global, max(allPossibleValues) + 0.3*yRange_global];
            for n = startIdx:endIdx
                cla(app.UIAxes);
                hold(app.UIAxes, 'on');
                current_n = conv_t(n);
                h_flipped = fliplr(h_extended);
                t_h_flipped = -fliplr(t_extended);
                h_shifted = interp1(t_h_flipped + current_n, h_flipped, t_extended, 'nearest', 0);
                product = x_extended .* h_shifted;
                x_nz = find(abs(x_extended) > 1e-10);
                h_nz = find(abs(h_shifted) > 1e-10);
                p_nz = find(abs(product) > 1e-10);
                if ~isempty(x_nz)
                    stem(app.UIAxes, t_extended(x_nz), x_extended(x_nz), 'b', 'filled', 'DisplayName', 'x[k]');
                end
                if ~isempty(h_nz)
                    stem(app.UIAxes, t_extended(h_nz), h_shifted(h_nz), 'r', 'filled', 'DisplayName', sprintf('h[%.1f-k]', current_n));
                end
                if ~isempty(p_nz)
                    stem(app.UIAxes, t_extended(p_nz), product(p_nz), 'filled', 'Color', [1 0.5 0], 'DisplayName', 'x[k]·h[n-k]');
                end
                plot(app.UIAxes, conv_t(startIdx:n), conv_result(startIdx:n), 'g-', 'LineWidth', 2, 'DisplayName', 'y[n]');
                plot(app.UIAxes, current_n, conv_result(n), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
                plot(app.UIAxes, [x_min_global x_max_global], [0 0], 'k-', 'LineWidth', 0.5, 'HandleVisibility', 'off');
                hold(app.UIAxes, 'off');
                xlabel(app.UIAxes, 'Time (k)');
                ylabel(app.UIAxes, 'Amplitude');
                title(app.UIAxes, sprintf('Convolution at n = %.1f\ny[n] = Σ x[k]·h[n-k] = %.2f', current_n, conv_result(n)));
                legend(app.UIAxes, 'Location', 'northeast');
                grid(app.UIAxes, 'on');
                xlim(app.UIAxes, [x_min_global x_max_global]);
                ylim(app.UIAxes, ylim_global);
                app.UIAxes.YAxisLocation = 'origin';
                drawnow;
                pause(0.1);
            end
            pause(1.5);
            cla(app.UIAxes);
            stem(app.UIAxes, conv_t, conv_result, 'g', 'filled', 'LineWidth', 1.5);
            hold(app.UIAxes, 'on');
            plot(app.UIAxes, [conv_t(1) conv_t(end)], [0 0], 'k-', 'LineWidth', 0.5);
            hold(app.UIAxes, 'off');
            xlabel(app.UIAxes, 'Time (n)');
            ylabel(app.UIAxes, 'Amplitude');
            title(app.UIAxes, sprintf('Final Convolution: (%s) * (%s)', app.signal1_name, app.signal2_name));
            grid(app.UIAxes, 'on');
            yRange = max(max(conv_result) - min(conv_result), 2);
            ylim(app.UIAxes, [min(conv_result) - 0.3*yRange, max(conv_result) + 0.3*yRange]);
            app.UIAxes.YAxisLocation = 'origin';
        end
    end

    methods (Access = public)
        function app = ArabitPlate2
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