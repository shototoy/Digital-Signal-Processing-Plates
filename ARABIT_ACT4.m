classdef ArabitPlate4 < matlab.apps.AppBase
    properties (Access = public)
        UIFigure matlab.ui.Figure
        OriginalAxes matlab.ui.control.UIAxes
        ProcessedAxes matlab.ui.control.UIAxes
        Sidebar matlab.ui.container.Panel
        LoadButton matlab.ui.control.Button
        OperationButtonGroup matlab.ui.container.ButtonGroup
        OpRadio_Grayscale matlab.ui.control.RadioButton
        OpRadio_Blur matlab.ui.control.RadioButton
        OpRadio_Edge matlab.ui.control.RadioButton
        OpRadio_Sharpen matlab.ui.control.RadioButton
        OpRadio_Negative matlab.ui.control.RadioButton
        FilterSizeLabel matlab.ui.control.Label
        FilterSizeSlider matlab.ui.control.Slider
        ApplyButton matlab.ui.control.Button
        ResetButton matlab.ui.control.Button
        OriginalImage
        ProcessedImage
    end

    methods (Access = private)
        function updatePlot(app, ax, img, titleStr)
            imshow(img, 'Parent', ax);
            title(ax, titleStr);
            axis(ax, 'image');
            ax.XTick = [];
            ax.YTick = [];
        end
        
        function LoadButtonPushed(app, ~)
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files (*.jpg, *.png, *.bmp)'});
            if isequal(file, 0)
                return;
            end
            fullPath = fullfile(path, file);
            app.OriginalImage = imread(fullPath);
            app.ProcessedImage = app.OriginalImage;
            updatePlot(app, app.OriginalAxes, app.OriginalImage, 'Original Image');
            updatePlot(app, app.ProcessedAxes, app.ProcessedImage, 'Processed Image');
            app.ApplyButton.Enable = 'on';
            app.ResetButton.Enable = 'on';
        end
        
        function ApplyButtonPushed(app, ~)
            if isempty(app.OriginalImage)
                uialert(app.UIFigure, 'Please load an image first.', 'No Image');
                return;
            end
            op = app.OperationButtonGroup.SelectedObject.Text;
            kernelSize = round(app.FilterSizeSlider.Value);
            if mod(kernelSize, 2) == 0
                kernelSize = kernelSize + 1;
            end
            img = double(app.OriginalImage);
            if size(img, 3) == 3
                imgGray = 0.2989 * img(:,:,1) + 0.5870 * img(:,:,2) + 0.1140 * img(:,:,3);
            else
                imgGray = img;
            end
            output = img;
            switch op
                case 'Grayscale'
                    output = imgGray;
                case 'Box Blur (Avg)'
                    h = ones(kernelSize) / (kernelSize^2);
                    if size(img, 3) == 3
                        output(:,:,1) = conv2(img(:,:,1), h, 'same');
                        output(:,:,2) = conv2(img(:,:,2), h, 'same');
                        output(:,:,3) = conv2(img(:,:,3), h, 'same');
                    else
                        output = conv2(img, h, 'same');
                    end
                case 'Edge Detect (Sobel)'
                    Gx = [-1 0 1; -2 0 2; -1 0 1];
                    Gy = [-1 -2 -1; 0 0 0; 1 2 1];
                    resX = conv2(imgGray, Gx, 'same');
                    resY = conv2(imgGray, Gy, 'same');
                    output = sqrt(resX.^2 + resY.^2);
                case 'Sharpen'
                    h = [0 -1 0; -1 5 -1; 0 -1 0];
                    if size(img, 3) == 3
                        output(:,:,1) = conv2(img(:,:,1), h, 'same');
                        output(:,:,2) = conv2(img(:,:,2), h, 'same');
                        output(:,:,3) = conv2(img(:,:,3), h, 'same');
                    else
                        output = conv2(img, h, 'same');
                    end
                case 'Negative'
                    output = 255 - img;
            end
            output(output < 0) = 0;
            output(output > 255) = 255;
            app.ProcessedImage = uint8(output);
            updatePlot(app, app.ProcessedAxes, app.ProcessedImage, ['Result: ' op]);
        end
        
        function ResetButtonPushed(app, ~)
            if isempty(app.OriginalImage)
                return;
            end
            app.ProcessedImage = app.OriginalImage;
            updatePlot(app, app.ProcessedAxes, app.ProcessedImage, 'Processed Image');
        end
        
        function SliderValueChanged(app, ~)
            val = round(app.FilterSizeSlider.Value);
            if mod(val, 2) == 0; val = val + 1; end
            app.FilterSizeLabel.Text = sprintf('Kernel Size: %dx%d', val, val);
        end
    end

    methods (Access = private)
        function createComponents(app)
            color_DeepBlue_RGB = [0.016 0.529 0.851];
            color_LightBlue_RGB = [0.016 0.616 0.851];
            color_VeryLightBlue_RGB = [0.769 0.933 0.949];
            color_Orange_RGB = [0.949 0.671 0.427];
            color_Beige_RGB = [0.949 0.839 0.741];
            
            app.UIFigure = uifigure('Visible', 'off', 'Position', [100 100 1000 600], 'Name', 'Arabit Plate#4');
            app.UIFigure.Color = color_VeryLightBlue_RGB;
            
            sidebarWidth = 250;
            app.Sidebar = uipanel(app.UIFigure);
            app.Sidebar.Position = [1000-sidebarWidth 0 sidebarWidth 600];
            app.Sidebar.BackgroundColor = color_DeepBlue_RGB;
            app.Sidebar.BorderType = 'none';
            
            imgAreaWidth = 1000 - sidebarWidth;
            axW = (imgAreaWidth - 60) / 2;
            axH = 400;
            axY = 100;
            
            app.OriginalAxes = uiaxes(app.UIFigure, 'Position', [20 axY axW axH]);
            title(app.OriginalAxes, 'Original Image');
            app.OriginalAxes.XTick = [];
            app.OriginalAxes.YTick = [];
            app.OriginalAxes.Box = 'on';
            app.OriginalAxes.BackgroundColor = [0.95 0.95 0.95];
            
            app.ProcessedAxes = uiaxes(app.UIFigure, 'Position', [20+axW+20 axY axW axH]);
            title(app.ProcessedAxes, 'Processed Image');
            app.ProcessedAxes.XTick = [];
            app.ProcessedAxes.YTick = [];
            app.ProcessedAxes.Box = 'on';
            app.ProcessedAxes.BackgroundColor = [0.95 0.95 0.95];

            uilabel(app.Sidebar, 'Position', [25 550 200 30], 'Text', 'IMAGE OPS', 'FontColor', 'white', 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
            
            app.LoadButton = uibutton(app.Sidebar, 'push', 'Position', [25 500 200 45], 'Text', 'LOAD IMAGE');
            app.LoadButton.ButtonPushedFcn = createCallbackFcn(app, @LoadButtonPushed, true);
            app.LoadButton.BackgroundColor = color_Orange_RGB;
            app.LoadButton.FontColor = 'white';
            app.LoadButton.FontSize = 14;
            app.LoadButton.FontWeight = 'bold';
            
            app.OperationButtonGroup = uibuttongroup(app.Sidebar, 'Position', [25 250 200 230], 'Title', 'Select Operation');
            app.OperationButtonGroup.BackgroundColor = color_LightBlue_RGB;
            app.OperationButtonGroup.ForegroundColor = 'white';
            
            app.OpRadio_Grayscale = uiradiobutton(app.OperationButtonGroup, 'Text', 'Grayscale', 'Position', [10 180 150 22], 'FontColor', 'white');
            app.OpRadio_Blur = uiradiobutton(app.OperationButtonGroup, 'Text', 'Box Blur (Avg)', 'Position', [10 150 150 22], 'FontColor', 'white');
            app.OpRadio_Sharpen = uiradiobutton(app.OperationButtonGroup, 'Text', 'Sharpen', 'Position', [10 120 150 22], 'FontColor', 'white');
            app.OpRadio_Edge = uiradiobutton(app.OperationButtonGroup, 'Text', 'Edge Detect (Sobel)', 'Position', [10 90 150 22], 'FontColor', 'white');
            app.OpRadio_Negative = uiradiobutton(app.OperationButtonGroup, 'Text', 'Negative', 'Position', [10 60 150 22], 'FontColor', 'white');
            
            app.FilterSizeLabel = uilabel(app.Sidebar, 'Position', [25 210 200 22], 'Text', 'Kernel Size: 3x3', 'FontColor', 'white');
            app.FilterSizeSlider = uislider(app.Sidebar, 'Position', [25 200 200 3], 'Limits', [3 15], 'Value', 3);
            app.FilterSizeSlider.ValueChangedFcn = createCallbackFcn(app, @SliderValueChanged, true);
            app.FilterSizeSlider.MajorTicks = [3 5 7 9 11 13 15];
            
            app.ApplyButton = uibutton(app.Sidebar, 'push', 'Position', [25 100 200 40], 'Text', 'APPLY FILTER');
            app.ApplyButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyButtonPushed, true);
            app.ApplyButton.BackgroundColor = color_VeryLightBlue_RGB;
            app.ApplyButton.FontColor = 'black';
            app.ApplyButton.Enable = 'off';
            
            app.ResetButton = uibutton(app.Sidebar, 'push', 'Position', [25 50 200 40], 'Text', 'RESET');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.BackgroundColor = color_Beige_RGB;
            app.ResetButton.Enable = 'off';

            footerLbl = uilabel(app.Sidebar);
            footerLbl.Position = [10 10 230 30];
            footerLbl.Text = {'Jule Cyrus Arabit'; 'Plate #4'};
            footerLbl.FontColor = color_VeryLightBlue_RGB;
            footerLbl.HorizontalAlignment = 'center';
            footerLbl.FontSize = 10;
            
            app.UIFigure.Visible = 'on';
        end
    end

    methods (Access = public)
        function app = ArabitPlate4
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
