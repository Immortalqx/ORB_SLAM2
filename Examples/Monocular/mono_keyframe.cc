/**
* This file is part of ORB-SLAM2.
*
* Copyright (C) 2014-2016 Raúl Mur-Artal <raulmur at unizar dot es> (University of Zaragoza)
* For more information see <https://github.com/raulmur/ORB_SLAM2>
*
* ORB-SLAM2 is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* ORB-SLAM2 is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with ORB-SLAM2. If not, see <http://www.gnu.org/licenses/>.
*/


#include<iostream>
#include<chrono>
#include<opencv2/core/core.hpp>
#include<System.h>
#include<unistd.h>

using namespace std;

int main(int argc, char **argv)
{
    // step 0 检查输入参数个数是否足够
    if (argc != 5)
    {
        cerr << endl << "Usage: ./mono_tum path_to_vocabulary path_to_settings path_to_video_file saved_file_name"
             << endl;
        return 1;
    }

    // step 1 加载视频
    // load video

    cv::VideoCapture capture;
    capture.open(argv[3]);

    if (!capture.isOpened())
    {
        cerr << "ERROR: Failed to load video" << endl;
        return 1;
    }

    // step 2 加载SLAM系统
    // Create SLAM system. It initializes all system threads and gets ready to process frames.
    ORB_SLAM2::System SLAM(
            argv[1],                            // path_to_vocabulary
            argv[2],                            // path_to_settings
            ORB_SLAM2::System::MONOCULAR,       // 单目模式
            true);                              // 启用可视化查看器

    // Main loop
    // step 3 依次追踪序列中的每一张图像
    cv::Mat im;
    double tframe = 0;
    while (capture.read(im))
    {
        // step 4.2 图像的合法性检查
        if (im.empty())
        {
            cerr << endl << "Failed to load image" << endl;
            continue;
        }
        try
        {
            cv::resize(im, im, cv::Size(1280, 720));
        } catch (...)
        {
            cerr << endl << "Resize error" << endl;
            continue;
        }
        tframe += 100;

        // step 4.3 开始计时
        std::chrono::steady_clock::time_point t1 = std::chrono::steady_clock::now();

        // Pass the image to the SLAM system
        // step 4.4 追踪当前图像
        SLAM.TrackMonocular(im, tframe / 1e9);

        // step 4.5 追踪完成,停止当前帧的图像计时, 并计算追踪耗时
        std::chrono::steady_clock::time_point t2 = std::chrono::steady_clock::now();
        double ttrack = std::chrono::duration_cast < std::chrono::duration < double > > (t2 - t1).count();

        // Wait to load the next frame
        // 期望按照30Hz的频率运行
        double T = 1.0 / 30.0;

        if (ttrack < T)
            usleep((T - ttrack) * 1e6);
    }

    // step 5 如果所有的图像都预测完了,那么终止当前的SLAM系统
    // Stop all threads
    SLAM.Shutdown();

    SLAM.SaveKeyFrameIDandPose(argv[4]);

    return 0;
}
