/*
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**
 * @file Intel VAAPI-accelerated encoding API usage example
 * @example vaapi_encode.c
 *
 * Perform VAAPI-accelerated encoding. Read input from an NV12 raw
 * file, and write the H.264 encoded data to an output raw file.
 * Usage: vaapi_encode 1920 1080 input.yuv output.h264
 */
#include "config.h"

#include <stdio.h>
#include <string.h>
#include <errno.h>

#include <libavcodec/avcodec.h>
#include <libavutil/pixdesc.h>
#include <libavutil/hwcontext.h>

#if CONFIG_D3D11VA
#include <libavutil/hwcontext_d3d11va.h>
#endif

static int width, height;
static enum AVPixelFormat hw_pix_fmt;
static enum AVHWDeviceType hw_device_type;
static AVBufferRef *hw_device_ctx = NULL;

static int set_hwframe_ctx(AVCodecContext *ctx, AVBufferRef *hw_device_ctx)
{
    AVBufferRef *hw_frames_ref;
    AVHWFramesContext *frames_ctx = NULL;
    int err = 0;

    if (!(hw_frames_ref = av_hwframe_ctx_alloc(hw_device_ctx))) {
        fprintf(stderr, "Failed to create %s frame context.\n", av_hwdevice_get_type_name(hw_device_type));
        return -1;
    }
    frames_ctx = (AVHWFramesContext *)(hw_frames_ref->data);
    frames_ctx->format    = hw_pix_fmt;
    frames_ctx->sw_format = AV_PIX_FMT_NV12;
    frames_ctx->width     = width;
    frames_ctx->height    = height;
    frames_ctx->initial_pool_size = 20;

#if CONFIG_D3D11VA
    if (hw_device_type == AV_HWDEVICE_TYPE_D3D11VA) {
        AVD3D11VAFramesContext *frames_hwctx = frames_ctx->hwctx;
        //frames_hwctx->BindFlags = D3D11_BIND_VIDEO_ENCODER;
        //frames_hwctx->MiscFlags = D3D11_RESOURCE_MISC_SHARED;
    }
#endif

    if ((err = av_hwframe_ctx_init(hw_frames_ref)) < 0) {
        fprintf(stderr, "Failed to initialize %s frame context."
                "Error code: %s\n", av_hwdevice_get_type_name(hw_device_type), av_err2str(err));
        av_buffer_unref(&hw_frames_ref);
        return err;
    }
    ctx->hw_frames_ctx = av_buffer_ref(hw_frames_ref);
    if (!ctx->hw_frames_ctx)
        err = AVERROR(ENOMEM);

    av_buffer_unref(&hw_frames_ref);
    return err;
}

static int encode_write(AVCodecContext *avctx, AVFrame *frame, FILE *fout)
{
    int ret = 0;
    AVPacket *enc_pkt;

    if (!(enc_pkt = av_packet_alloc()))
        return AVERROR(ENOMEM);

    if ((ret = avcodec_send_frame(avctx, frame)) < 0) {
        fprintf(stderr, "Error code: %s\n", av_err2str(ret));
        goto end;
    }
    while (1) {
        ret = avcodec_receive_packet(avctx, enc_pkt);
        if (ret)
            break;

        enc_pkt->stream_index = 0;
        ret = fwrite(enc_pkt->data, enc_pkt->size, 1, fout);
        av_packet_unref(enc_pkt);
    }

end:
    av_packet_free(&enc_pkt);
    ret = ((ret == AVERROR(EAGAIN)) ? 0 : -1);
    return ret;
}

int main(int argc, char *argv[])
{
    int i, size, err;
    FILE *fin = NULL, *fout = NULL;
    AVFrame *sw_frame = NULL, *hw_frame = NULL;
    AVCodecContext *avctx = NULL;
    const AVCodec *codec = NULL;
    const char *device = NULL;
    char buf[1024] = {0};

    if (argc < 6) {
        fprintf(stderr, "Usage: %s <width> <height> <input file> <output file> <codec name>\n", argv[0]);
        return -1;
    }

    width  = atoi(argv[1]);
    height = atoi(argv[2]);
    size   = width * height;

    if (!(fin = fopen(argv[3], "rb"))) {
        fprintf(stderr, "Fail to open input file : %s\n", strerror(errno));
        return -1;
    }
    if (!(fout = fopen(argv[4], "w+b"))) {
        fprintf(stderr, "Fail to open output file : %s\n", strerror(errno));
        err = -1;
        goto close;
    }

    if (!(codec = avcodec_find_encoder_by_name(argv[5]))) {
        fprintf(stderr, "Could not find %s encoder.\n", argv[5]);
        err = -1;
        goto close;
    }

#if 0
    for (i=0;; i++) {
        const AVCodecHWConfig *config = avcodec_get_hw_config(codec, i);
        if (!config) {
            fprintf(stderr, "Decoder %s does not support device.\n",
                    codec->name);
            break;
        }
        if (config->methods & AV_CODEC_HW_CONFIG_METHOD_HW_FRAMES_CTX) {
            hw_pix_fmt = config->pix_fmt;
            hw_device_type = config->device_type;
            break;
        }
    }

    printf("Device type name '%s', Pixel format '%s'\n", av_hwdevice_get_type_name(hw_device_type), av_get_pix_fmt_name(hw_pix_fmt));

#else
    printf("\nPlease select device\n");

    err = 0;
    for (i = 0;; i++) {
        const AVCodecHWConfig *config = avcodec_get_hw_config(codec, i);
        if (!config)
            break;
        if (config->methods & AV_CODEC_HW_CONFIG_METHOD_HW_FRAMES_CTX) {
            hw_pix_fmt = config->pix_fmt;
            hw_device_type = config->device_type;
            err++;
            printf("\t %d: Device type name '%s', Pixel format '%s'\n", i, av_hwdevice_get_type_name(hw_device_type), av_get_pix_fmt_name(hw_pix_fmt));
        }
    }

    if (err > 1) {
resel:        
        printf("\nPlease input index: ");
    
        i = atoi(fgets(buf, sizeof(buf) - 1, stdin));

        const AVCodecHWConfig *config = avcodec_get_hw_config(codec, i);
        if (!config)
            goto resel;
      
        if (config->methods & AV_CODEC_HW_CONFIG_METHOD_HW_FRAMES_CTX) {
            hw_pix_fmt = config->pix_fmt;
            hw_device_type = config->device_type;
        } else {
            goto resel;
        }
    }
#endif

    if (hw_device_type == AV_HWDEVICE_TYPE_QSV)
        device = "auto";
    else if (hw_device_type == AV_HWDEVICE_TYPE_D3D11VA)
        device = "d3d11va";
  
    err = av_hwdevice_ctx_create(&hw_device_ctx, hw_device_type,
                                 device, NULL, 0);
    if (err < 0) {
        fprintf(stderr, "Failed to create a %s device. Error code: %s\n", av_hwdevice_get_type_name(hw_device_type), av_err2str(err));
        goto close;
    }

    if (!(avctx = avcodec_alloc_context3(codec))) {
        fprintf(stderr, "Failed to alloc context\n");
        err = AVERROR(ENOMEM);
        goto close;
    }

    avctx->width     = width;
    avctx->height    = height;
    avctx->time_base = (AVRational){1, 25};
    avctx->framerate = (AVRational){25, 1};
    avctx->sample_aspect_ratio = (AVRational){1, 1};
    avctx->pix_fmt   = hw_pix_fmt;

    /* set hw_frames_ctx for encoder's AVCodecContext */
    if ((err = set_hwframe_ctx(avctx, hw_device_ctx)) < 0) {
        fprintf(stderr, "Failed to set hwframe context.\n");
        goto close;
    }

    if ((err = avcodec_open2(avctx, codec, NULL)) < 0) {
        fprintf(stderr, "Cannot open video encoder codec. Error code: %s\n", av_err2str(err));
        goto close;
    }

    while (1) {
        if (!(sw_frame = av_frame_alloc())) {
            fprintf(stderr, "Failed to alloc frame\n");
            err = AVERROR(ENOMEM);
            goto close;
        }
        /* read data into software frame, and transfer them into hw frame */
        sw_frame->width  = width;
        sw_frame->height = height;
        sw_frame->format = AV_PIX_FMT_NV12;
        if ((err = av_frame_get_buffer(sw_frame, 0)) < 0) {
            fprintf(stderr, "Failed to get frame buffer\n");
            goto close;
        }
        if ((err = fread((uint8_t*)(sw_frame->data[0]), size, 1, fin)) <= 0) {
            fprintf(stderr, "Failed to read Y\n");
            break;
        }
        if ((err = fread((uint8_t*)(sw_frame->data[1]), size/2, 1, fin)) <= 0) {
            fprintf(stderr, "Failed to read UV\n");
            break;
        }

        if (!(hw_frame = av_frame_alloc())) {
            err = AVERROR(ENOMEM);
            goto close;
        }
        if ((err = av_hwframe_get_buffer(avctx->hw_frames_ctx, hw_frame, 0)) < 0) {
            fprintf(stderr, "Error code: %s.\n", av_err2str(err));
            goto close;
        }
        if (!hw_frame->hw_frames_ctx) {
            err = AVERROR(ENOMEM);
            goto close;
        }
        if ((err = av_hwframe_transfer_data(hw_frame, sw_frame, 0)) < 0) {
            fprintf(stderr, "Error while transferring frame data to surface."
                    "Error code: %s.\n", av_err2str(err));
            goto close;
        }

        if ((err = (encode_write(avctx, hw_frame, fout))) < 0) {
            fprintf(stderr, "Failed to encode.\n");
            goto close;
        }
        av_frame_free(&hw_frame);
        av_frame_free(&sw_frame);
    }

    /* flush encoder */
    err = encode_write(avctx, NULL, fout);
    if (err == AVERROR_EOF)
        err = 0;

close:
    if (fin)
        fclose(fin);
    if (fout)
        fclose(fout);
    av_frame_free(&sw_frame);
    av_frame_free(&hw_frame);
    avcodec_free_context(&avctx);
    av_buffer_unref(&hw_device_ctx);

    return err;
}
