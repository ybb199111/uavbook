classdef spacecraft_viewer < handle %属于handle类
    %
    %    Create spacecraft animation
    %
    %--------------------------------
    properties
        body_handle
    	Vertices
    	Faces
    	facecolors
        plot_initialized
    end
    %--------------------------------
    methods
        %类定义可以包含多个方法块，每个块指定不同的属性设置，这些设置适用于该特定块中的方法。
        %可以在单独的文件中定义方法函数。
        %------constructor-----------构造函数
        function self = spacecraft_viewer
            self.body_handle = [];%body_handle初始化为空
            [self.Vertices, self.Faces, self.facecolors] = self.define_spacecraft();%调用
            self.plot_initialized = 0;           
        end
        %---------------------------
        function self=update(self, state)  %更新Spacecraft的状态
            if self.plot_initialized==0
                figure(1);
                %clf;%清除原有figure的内容
                self=self.drawBody(state.pn, state.pe, -state.h,...
                                   state.phi, state.theta, state.psi);
                title('Spacecraft')
                xlabel('East')
                ylabel('North')
                zlabel('-Down')
                view(32,47)  % set the vieew angle for figure
                axis([-10,10,-10,10,-10,10]);
                hold on
                grid on
                self.plot_initialized = 1;%初始化之后，该值就变为1了
            else
                self=self.drawBody(state.pn, state.pe, -state.h,... 
                                   state.phi, state.theta, state.psi);

            end
        end
        %---------------------------
        function self = drawBody(self, pn, pe, pd, phi, theta, psi)
            Vertices = self.rotate(self.Vertices, phi, theta, psi);   % rotate rigid body   点的旋转
            Vertices = self.translate(Vertices, pn, pe, pd);     % translate after rotation  点的平移
            % transform vertices from NED to ENU (for matlab rendering)
            R = [...
                0, 1, 0;...
                1, 0, 0;...
                0, 0, -1;...
                ];
            Vertices = R*Vertices;
            if isempty(self.body_handle) %初始化时是空的
                self.body_handle = patch('Vertices', Vertices', 'Faces', self.Faces,...
                                             'FaceVertexCData',self.facecolors,...
                                             'FaceColor','flat');%查看Patch函数
            else
                set(self.body_handle,'Vertices',Vertices','Faces',self.Faces);%设置图像属性，
                drawnow
            end
        end 
        %---------------------------
        function pts=rotate(self, pts, phi, theta, psi)  
            %旋转的函数
            % define rotation matrix (right handed)
            R_roll = [...
                        1, 0, 0;...
                        0, cos(phi), sin(phi);...
                        0, -sin(phi), cos(phi)];
            R_pitch = [...
                        cos(theta), 0, -sin(theta);...
                        0, 1, 0;...
                        sin(theta), 0, cos(theta)];
            R_yaw = [...
                        cos(psi), sin(psi), 0;...
                        -sin(psi), cos(psi), 0;...
                        0, 0, 1];
            R = R_roll*R_pitch*R_yaw;   % inertial to body惯性系到机体系
            R = R';  % body to inertial 机体系到惯性系
            % rotate vertices 
            pts = R*pts;  %得到的是3*12的矩阵
        end
        %---------------------------
        % translate vertices by pn, pe, pd
        function pts = translate(self, pts, pn, pe, pd)
            %平移的函数
            pts = pts + repmat([pn;pe;pd],1,size(pts,2));%让Vertices的每一列都加[pn;pe;pd]
        end
        %---------------------------
        function [V, F, colors] = define_spacecraft(self)%定义spacecraft的点、面由几个点组成、面的颜色
            % Define the vertices (physical location of vertices)
            V = [...
                1    1    0;... % point 1
                1   -1    0;... % point 2
                -1   -1    0;... % point 3
                -1    1    0;... % point 4
                1    1   -2;... % point 5
                1   -1   -2;... % point 6
                -1   -1   -2;... % point 7
                -1    1   -2;... % point 8
                1.5  1.5  0;... % point 9
                1.5 -1.5  0;... % point 10
                -1.5 -1.5  0;... % point 11
                -1.5  1.5  0;... % point 12
            ]';%注意转置符号

            % define faces as a list of vertices numbered above
            F = [...
                    1, 2,  6,  5;...  % front
                    4, 3,  7,  8;...  % back
                    1, 5,  8,  4;...  % right 
                    2, 6,  7,  3;...  % left
                    5, 6,  7,  8;...  % top
                    9, 10, 11, 12;... % bottom
                    ];

            % define colors for each face    
            myred = [1, 0, 0];
            mygreen = [0, 1, 0];
            myblue = [0, 0, 1];
            myyellow = [1, 1, 0];
            mycyan = [0, 1, 1];

            colors = [...
                myyellow;... % front
                myblue;...   % back
                myblue;...   % right
                myblue;...   % left
                myblue;...   % top
                mygreen;...  % bottom
                ];
        end
    end
end