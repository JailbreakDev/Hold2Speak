ARCHS = armv7 armv7s arm64
include theos/makefiles/common.mk

TWEAK_NAME = Hold2Speak
Hold2Speak_FILES = Hold2Speak.xm
Hold2Speak_FRAMEWORKS = UIKit CoreFoundation AVFoundation
Hold2Speak_PRIVATE_FRAMEWORKS = CoreTelephony AudioToolbox

include $(THEOS_MAKE_PATH)/tweak.mk


