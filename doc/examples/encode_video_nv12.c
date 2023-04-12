/*
 * Copyright (c) 2001 Fabrice Bellard
 *
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
 * @file
 * video encoding with libavcodec API example
 *
 * @example encode_video.c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <libavcodec/avcodec.h>

#include <libavutil/opt.h>
#include <libavutil/imgutils.h>

static void encode(AVCodecContext *enc_ctx, AVFrame *frame, AVPacket *pkt,
                   FILE *fout)
{
    int ret;

    ret = avcodec_send_frame(enc_ctx, frame);
    if (ret < 0) {
        fprintf(stderr, "Error sending a frame for encoding\n");
        exit(1);
    }

    while (ret >= 0) {
        ret = avcodec_receive_packet(enc_ctx, pkt);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF)
            return;
        else if (ret < 0) {
            fprintf(stderr, "Error during encoding\n");
            exit(1);
        }

        fwrite(pkt->data, 1, pkt->size, fout);
        av_packet_unref(pkt);
    }
}

int main(int argc, char **argv)
{
    const AVCodec *codec;
    AVCodecContext *c= NULL;
    AVDictionary *opts = NULL;
    int i, ret, err, width, height, size;
    FILE *fin, *fout;
    AVFrame *frame;
    AVPacket *pkt;

    if (argc <= 5) {
        fprintf(stderr, "Usage: %s <width> <height> <input file> <output file> <codec name>\n", argv[0]);
        exit(0);
    }
    width  = atoi(argv[1]);
    height = atoi(argv[2]);
    size   = width * height;


    if (!(fin = fopen(argv[3], "rb"))) {
        fprintf(stderr, "Fail to open input file : %s\n", strerror(errno));
        exit(1);
    }
    if (!(fout = fopen(argv[4], "w+b"))) {
        fprintf(stderr, "Fail to open output file : %s\n", strerror(errno));
        exit(1);
    }

    /* find the mpeg1video encoder */
    codec = avcodec_find_encoder_by_name(argv[5]);
    if (!codec) {
        fprintf(stderr, "Codec '%s' not found\n", argv[5]);
        exit(1);
    }

    c = avcodec_alloc_context3(codec);
    if (!c) {
        fprintf(stderr, "Could not allocate video codec context\n");
        exit(1);
    }

    pkt = av_packet_alloc();
    if (!pkt)
        exit(1);

    /* put sample parameters */
    c->bit_rate = 400000;
    /* resolution must be a multiple of two */
    c->width = width;
    c->height = height;
    /* frames per second */
    c->time_base = (AVRational){1, 25};
    c->framerate = (AVRational){25, 1};

    /* emit one intra frame every ten frames
     * check frame pict_type before passing frame
     * to encoder, if frame->pict_type is AV_PICTURE_TYPE_I
     * then gop_size is ignored and the output of encoder
     * will always be I frame irrespective to gop_size
     */
    c->gop_size = 10;
    c->max_b_frames = 1;
    c->pix_fmt = AV_PIX_FMT_NV12;

    if (codec->pix_fmts) {
        for (i = 0; codec->pix_fmts[i] != AV_PIX_FMT_NONE; i++)
            if (c->pix_fmt == codec->pix_fmts[i])
                break;
        if (codec->pix_fmts[i] == AV_PIX_FMT_NONE) {
            fprintf(stderr, "Could not pix fmt\n");
        	exit(1);
        }
    }

    // h264_mf  
    av_dict_set(&opts, "rate_control", "quality", 0);

    /* open it */
    ret = avcodec_open2(c, codec, &opts);
    if (ret < 0) {
        fprintf(stderr, "Could not open codec: %s\n", av_err2str(ret));
        exit(1);
    }

    frame = av_frame_alloc();
    if (!frame) {
        fprintf(stderr, "Could not allocate video frame\n");
        exit(1);
    }
    frame->format = c->pix_fmt;
    frame->width  = c->width;
    frame->height = c->height;

    ret = av_frame_get_buffer(frame, 0);
    if (ret < 0) {
        fprintf(stderr, "Could not allocate the video frame data\n");
        exit(1);
    }
    
    i = 0;
    
    /* encode 1 second of video */
    while (1) {
        /* Make sure the frame data is writable.
           On the first round, the frame is fresh from av_frame_get_buffer()
           and therefore we know it is writable.
           But on the next rounds, encode() will have called
           avcodec_send_frame(), and the codec may have kept a reference to
           the frame in its internal structures, that makes the frame
           unwritable.
           av_frame_make_writable() checks that and allocates a new buffer
           for the frame only if necessary.
         */
        ret = av_frame_make_writable(frame);
        if (ret < 0)
            exit(1);

        if ((err = fread((uint8_t*)(frame->data[0]), size, 1, fin)) <= 0)
            break;
        if ((err = fread((uint8_t*)(frame->data[1]), size/2, 1, fin)) <= 0)
            break;

        frame->pts = i++;

        /* encode the image */
        encode(c, frame, pkt, fout);
    }

    /* flush the encoder */
    encode(c, NULL, pkt, fout);

   
    fclose(fout);
    fclose(fin);

    av_dict_free(&opts);
    avcodec_free_context(&c);
    av_frame_free(&frame);
    av_packet_free(&pkt);

    return 0;
}
