#  ARLibrary
ARLibrary: AR 导航应用 —— AR 图书馆导航

## 演示视频

https://user-images.githubusercontent.com/37976199/158530636-c8f08495-547a-42e0-bcc1-5f8ac73d0d63.mp4

## Related posts

[AR 导航应用](https://blog.iswiftai.com/posts/ar-application/)

[AR 导航技术概览](https://blog.iswiftai.com/posts/ar-technolgy/)

## 简介
设计并实现以多源感知的室内定位技术为核心、以增强现实技术为可视化处理手段的软件，并将其应用到智慧校园图书馆中。
使用常见的智能手机，利用其内置的传感器如摄像头、陀螺仪、加速器、重力感应器等，使用惯性视觉里程计算法，实现多源感知的室内定位、导航；使用增强现实（AR）技术，使得虚拟的路线与实际的室内场景相结合，实现室内导航良好的可视化，提升导航的引导效果，增强导航的应用体验；使用图像检测技术，用于对图像的识别和检测，提升智慧图书馆的使用体验；在智慧图书馆应用中，使用基于加权迭代算法，用于文献资料推荐，进一步提升图书馆的利用价值。设计并开发了移动端应用软件，并在服务器端开发Web应用对移动端进行服务、数据支撑。综合上述技术应用，设计完成了完整的室内导航使用体验。

## 技术思路

### 惯性视觉里程计——实现AR

我们使用基于视觉惯性里程计（Visual Inertial Odometry, VIO）的ARKit框架来跟踪设备的移动和周围环境的变化。VIO将来自摄像机传感器的基于声画框架（AVFoundation）的输入与通过传感器（陀螺仪和加速器）（CoreMotion）捕获的设备运动数据融合在一起，这两个框架协同工作来支持AR的场景识别和跟踪。

![DraggedImage](https://blog.iswiftai.com/assets/img/images/2021/03/07/draggedimage.png)

### ARKit的工作流程

首先捕捉真实世界：真实世界一般由移动设备的摄像头完成。构建虚拟世界：虚拟世界的物体模型，可以有很多物体模型，从而组成一个复杂的虚拟世界。进而将虚拟世界与现实世界相结合：将虚拟世界渲染到捕捉到的真实世界中。与此同时还具备世界追踪功能：当真实世界变化时（如下图中移动摄像头），要能追踪到当前摄像机相对于初始时的位置、角度变化信息，以便实时渲染出虚拟世界相对于现实世界的位置和角度。最终实现场景解析：虚拟物体放在检测识别到的平面上，并有固定的坐标。

![DraggedImage-1](https://blog.iswiftai.com/assets/img/images/2021/03/07/draggedimage1.png)

### 图像识别匹配——实现初始位置校准

AR所使用的惯性视觉里程计可以实时地追踪设备的运动变化，但是无法单独的获取初始位置和方向。我们在室内场景已知位置放置特定的图片标识符，使用图像识别匹配来确定初始位置。

![DraggedImage-2](https://blog.iswiftai.com/assets/img/images/2021/03/07/draggedimage2.png)

所述方法包括首先灰度处理、寻找特征点，包括已知的标识图的特征点以及当前捕捉到的场景的特征点、特征点匹配，在当前的场景中匹配在标识图的特征点、投影几何，对图像的位置和方向进行估算、局部坐标建立。

## 效果演示

### 搜索书籍

![16150934205394](https://blog.iswiftai.com/assets/img/images/2021/03/07/16150934205394.png)

### AR导航确定初始位置

![16150936659000](https://blog.iswiftai.com/assets/img/images/2021/03/07/16150936659000.png)

### AR导航

![16150937693294](https://blog.iswiftai.com/assets/img/images/2021/03/07/16150937693294.png)

### 到终点识别图书封面

![16150938459493](https://blog.iswiftai.com/assets/img/images/2021/03/07/16150938459493.png)



## 创新点

### 相比传统导航的创新

传统的导航，采用二维平面显示路径以及所在位置的居多。而本项目的创新之处在于运用增强现实技术，通过手机的摄像头，将虚拟的导航规划路线，放置在手机的屏幕上，实现虚拟与现实巧妙结合，提升了在室内导航的可视化效果、引导的直观性大大提升，具有良好的可交互性，提升了用户体验。

![截屏2020-07-20 下午2.17.08](https://blog.iswiftai.com/assets/img/images/2021/03/07/jie-ping20200720-xia-wu21708.png)

### 室内导航技术

一般基于射频信号的室内导航，例如Wi-Fi、蓝牙定位等，需要构建信号网络，根据不同点，接收信号的强弱来计算所在位置，成本、功耗较高。
相比较而言，本系统采用惯性传感器，来采集一些参数信息，使用航位推算，实现室内导航，而目前被广泛使用的智能手机基本内置这些传感器，可以满足惯性导航的硬件需求，//因此具有低成本、高普适性的特点。

![截屏2020-07-20 下午2.18.18](https://blog.iswiftai.com/assets/img/images/2021/03/07/jie-ping20200720-xia-wu21818.png)

### 广阔应用前景

除高校图书馆之外，该项目的应用场景也非常丰富，例如城市图书馆、博物馆等，还可用于提供生活服务，例如大型购物商场的导航、机场航站楼的指引、以及大型地下停车库等等，采用系统化的构建方法，即可快速增加对新场景的应用支持。因此该项目的具有十分广阔的应用前景。

## 问题解答

### 为什么不用GPS呢，现在GPS在室内也能用？

GPS导航首先需要解决的是定位问题。简单来说，就是手持设备中的GPS接收芯片收到用于定位的卫星信号，并以此计算出设备坐标。

1. 由于GPS卫星信号功率极低，穿透能力很差，因此常常受到建筑墙体的阻隔而无法进入室内。
2. 即使室内有GPS信号，那么定位的精度也会大打折扣。而且我们所应对的场景例如图书馆、大型超市、地下车库等，导航的目的地所对应的物品都比较多且个体小，因此是需要较高的导航精度的。
3. 一般我们需要室内导航的场景往往是多层楼结构，如我们的图书馆、大型购物商场等。GPS定位是平面二维的，无法确定所在高度楼层位置。而我们所用的惯性导航，传感器是可以捕捉6自由度位置变化的，因此可以识别高度的变化。
4. 即使有了精确的定位结果，导航所依赖的地图信息在室内场景下也并不容易获得，所以实时室内导航就更无从谈起了。

### 为什么使用惯性导航呢？

1. 首先一种比较受欢迎的做法是基于蓝牙信标定位的导航方法。以苹果推出的iBeacon为例，在一个或多个iBeacon基站的帮助下，智能手机的软件能大致得到其在地图上的位置，从而进行路线规划和导航。但是由于蓝牙的传输距离较短，从而导致在大型室内环境（商场、写字楼）中会产生极高的部署和维护成本。
2. 另外一种解决方案是基于Wi-Fi信号进行定位和导航。相比蓝牙信标，Wi-Fi在室内环境中更加常见。与蓝牙方法类似，这类方法主要通过无线信号衰减模型和三角定位法确定移动设备的大致位置。亦有其他一些通过信号相位差、传输时间差、信道状态等方式的定位系统。但其本质都是利用来自不同Wi-Fi天线的信号差异及相互关系进行定位。
3. 此外，也可以利用机器学习算法将室内区域进行网格划分，根据每个区域的信号强度信息生成热力图进行训练，从而提高定位的准确性。但是由于室内环境的复杂性，Wi-Fi信号很容易受环境的变化而改变，因此维护成本依然很高、精度也受到Wi-Fi路由器部署密度、环境稳定性、训练时长等的制约。还有一些基于专用设备的解决方案。通过在室内各个区域部署大量的专业传感设备，包括RFID、红外线、超声波、摄像头甚至激光设备等等。这类解决方案虽然克服了精度问题，但是高昂的硬件成本也使其难以扩展和推广。
4. 最后，室内导航一般依赖于室内地图。而大型室内环境地图数据的采集、制作及表达等问题始终悬而未决，且耗费巨大，这为室内导航技术的普适应用打上了一个巨大的问号。


