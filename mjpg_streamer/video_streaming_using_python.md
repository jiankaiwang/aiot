# Video Streaming using Python



## Start video streaming



```shel
mjpg_streamer -i "input_uvc.so -d /dev/video0 -y -r 640x480 -f 60 -n" -o "output_http.so -p 8080 -w /opt/code/mjpg_streamer/www"
```

You can check whether the video streaming works by surfing the webpage http://localhost:8080/.



## Capture the Streaming



The following is the example to capture the streaming by using python.

```python
import cv2
import urllib2
import numpy as np
import sys

host = "localhost:8080"
if len(sys.argv)>1:
	host = sys.argv[1]
hoststr = 'http://' + host + '/?action=stream'
print 'Video streaming from ' + hoststr

print 'You can press Esc to quit.'
stream=urllib2.urlopen(hoststr)
bytes=''
while True:
    bytes += stream.read(1024)
    a = bytes.find('\xff\xd8')
    b = bytes.find('\xff\xd9')
    if a!=-1 and b!=-1:
        jpg = bytes[a:b+2]
        bytes = bytes[b+2:]
        
        #flags = 1 for color image
        img = cv2.imdecode(np.fromstring(jpg, dtype=np.uint8),flags=1)
        
        # print i.shape
        cv2.imshow("ImgShow", img)
        if cv2.waitKey(1) & 0xFF == ord('q'):
        	exit(0)
```

