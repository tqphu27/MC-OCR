python test.py --checkpoint /datausers/ioit/dungduc.student/MC_OCR/mc_ocr/key_info_extraction/PICK/model_best.pth
                --boxes_transcripts /datausers/ioit/dungduc.student/MC_OCR/output_results/key_info_extraction/public_test_pick/bboxes_and_transcripts \
               --images_path /datausers/ioit/dungduc.student/MC_OCR/output_results/key_info_extraction/public_test_pick/images
               --output_folder /datausers/ioit/dungduc.student/MC_OCR/output_results/key_info_extraction/public_test_pick/output \
               --gpu 2 --batch_size 8