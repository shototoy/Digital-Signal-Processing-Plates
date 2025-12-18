classdef ArabitPlate3 < matlab.apps.AppBase
    properties (Access = public)
        UIFigure matlab.ui.Figure
        TimeAxes matlab.ui.control.UIAxes
        FreqAxes matlab.ui.control.UIAxes
        Sidebar matlab.ui.container.Panel
        StartButton matlab.ui.control.Button
        ResetButton matlab.ui.control.Button
        HarmonicsEditField matlab.ui.control.NumericEditField
        HarmonicsLabel matlab.ui.control.Label
    end

    properties (Access = private)
        isAnimating logical = false
    end

    methods (Access = private)
        function StartButtonPushed(app, ~)
            if app.isAnimating
                return;
            end
            app.isAnimating = true;
            app.StartButton.Enable = 'off';
            app.ResetButton.Enable = 'off';
            
            t = linspace(-2*pi, 2*pi, 1000);
            squareWave = sign(sin(t));
            maxN = app.HarmonicsEditField.Value;
            n_vals = 1:2:(2*maxN); 
            cmap = jet(length(n_vals));
            currentSum = zeros(size(t));
            
            cla(app.TimeAxes);
            hold(app.TimeAxes, 'on');
            plot(app.TimeAxes, t, squareWave, 'k--', 'LineWidth', 2, 'DisplayName', 'Target Square Wave');
            grid(app.TimeAxes, 'on');
            title(app.TimeAxes, 'Fourier Series Convergence (Square Wave)');
            xlabel(app.TimeAxes, 'Time (t)');
            ylabel(app.TimeAxes, 'Amplitude');
            ylim(app.TimeAxes, [-1.5 1.5]);
            xlim(app.TimeAxes, [-2*pi 2*pi]);

            cla(app.FreqAxes);
            hold(app.FreqAxes, 'on');
            grid(app.FreqAxes, 'on');
            title(app.FreqAxes, 'Frequency Components (Harmonics)');
            xlabel(app.FreqAxes, 'Harmonic Number (n)');
            ylabel(app.FreqAxes, 'Amplitude (4/n\pi)');
            
            maxFreq = n_vals(end);
            xlim(app.FreqAxes, [0 maxFreq+2]);
            ylim(app.FreqAxes, [0 1.5]);
            
            for k = 1:length(n_vals)
                if ~isvalid(app) || ~isvalid(app.UIFigure) || ~app.isAnimating
                    break;
                end
                
                n = n_vals(k);
                amp = 4/(n*pi);
                
                harmonic = amp * sin(n*t);
                currentSum = currentSum + harmonic;
                color = cmap(k, :);
                
                stem(app.FreqAxes, n, amp, 'Color', color, 'MarkerFaceColor', color, 'LineWidth', 1.5, 'BaseValue', 0);
                plot(app.TimeAxes, t, currentSum, 'Color', color, 'LineWidth', 1.5, 'DisplayName', sprintf('Order %d', n));
                
                drawnow;
                if maxN > 20
                    pause(0.05);
                else
                    pause(0.3);
                end
            end
            
            app.isAnimating = false;
            app.StartButton.Enable = 'on';
            app.ResetButton.Enable = 'on';
        end

        function ResetButtonPushed(app, ~)
            app.isAnimating = false;
            cla(app.TimeAxes);
            cla(app.FreqAxes);
            
            t = linspace(-2*pi, 2*pi, 1000);
            plot(app.TimeAxes, t, sign(sin(t)), 'k--', 'LineWidth', 1);
            grid(app.TimeAxes, 'on');
            title(app.TimeAxes, 'Time Domain');
            ylim(app.TimeAxes, [-1.5 1.5]);
            
            title(app.FreqAxes, 'Frequency Domain');
            grid(app.FreqAxes, 'on');
        end
    end

    methods (Access = private)
        function createComponents(app)
            color_DeepBlue_RGB = [0.016 0.529 0.851];
            color_LightBlue_RGB = [0.016 0.616 0.851];
            color_VeryLightBlue_RGB = [0.769 0.933 0.949];
            color_Orange_RGB = [0.949 0.671 0.427];
            color_Beige_RGB = [0.949 0.839 0.741];
            
            app.UIFigure = uifigure('Visible', 'off', 'Position', [100 100 900 600], 'Name', 'Arabit Plate#3');
            app.UIFigure.Color = color_VeryLightBlue_RGB;
            
            sidebarWidth = 220;
            app.Sidebar = uipanel(app.UIFigure);
            app.Sidebar.Position = [900-sidebarWidth 0 sidebarWidth 600];
            app.Sidebar.BackgroundColor = color_DeepBlue_RGB;
            app.Sidebar.BorderType = 'none';
            
            axesWidth = 600;
            app.TimeAxes = uiaxes(app.UIFigure, 'Position', [40 320 axesWidth 250]);
            title(app.TimeAxes, 'Time Domain');
            xlabel(app.TimeAxes, 'Time');
            ylabel(app.TimeAxes, 'Amplitude');
            grid(app.TimeAxes, 'on');
            app.TimeAxes.BackgroundColor = 'white';
            
            app.FreqAxes = uiaxes(app.UIFigure, 'Position', [40 50 axesWidth 250]);
            title(app.FreqAxes, 'Frequency Domain');
            xlabel(app.FreqAxes, 'Frequency');
            ylabel(app.FreqAxes, 'Magnitude');
            grid(app.FreqAxes, 'on');
            app.FreqAxes.BackgroundColor = 'white';
            
            titleLabel = uilabel(app.Sidebar);
            titleLabel.Position = [10 550 200 40];
            titleLabel.Text = 'CONTROLS';
            titleLabel.FontColor = 'white';
            titleLabel.FontSize = 20;
            titleLabel.FontWeight = 'bold';
            titleLabel.HorizontalAlignment = 'center';

            app.HarmonicsLabel = uilabel(app.Sidebar);
            app.HarmonicsLabel.Position = [20 480 180 22];
            app.HarmonicsLabel.Text = 'Max Harmonics:';
            app.HarmonicsLabel.FontColor = 'white';
            app.HarmonicsLabel.FontSize = 14;
            
            app.HarmonicsEditField = uieditfield(app.Sidebar, 'numeric');
            app.HarmonicsEditField.Position = [20 450 180 30];
            app.HarmonicsEditField.Value = 10;
            app.HarmonicsEditField.FontSize = 14;
            app.HarmonicsEditField.HorizontalAlignment = 'center';
            app.HarmonicsEditField.BackgroundColor = color_VeryLightBlue_RGB;

            app.StartButton = uibutton(app.Sidebar, 'push');
            app.StartButton.Position = [20 380 180 50];
            app.StartButton.Text = 'START ANIMATION';
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.BackgroundColor = color_Orange_RGB;
            app.StartButton.FontColor = 'white';
            app.StartButton.FontSize = 14;
            app.StartButton.FontWeight = 'bold';
            
            app.ResetButton = uibutton(app.Sidebar, 'push');
            app.ResetButton.Position = [20 320 180 50];
            app.ResetButton.Text = 'RESET';
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.BackgroundColor = color_Beige_RGB;
            app.ResetButton.FontColor = [0.2 0.2 0.2];
            app.ResetButton.FontSize = 14;
            app.ResetButton.FontWeight = 'bold';
            
            footerLbl = uilabel(app.Sidebar);
            footerLbl.Position = [10 20 200 40];
            footerLbl.Text = {'Jule Cyrus Arabit'; 'Plate #3'};
            footerLbl.FontColor = color_VeryLightBlue_RGB;
            footerLbl.HorizontalAlignment = 'center';
            footerLbl.FontSize = 10;

            app.UIFigure.Visible = 'on';
        end
    end

    methods (Access = public)
        function app = ArabitPlate3
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